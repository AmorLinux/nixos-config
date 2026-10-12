#!/usr/bin/env bash
# pi-sandbox.sh — arranca Pi dentro de Docker (patron oficial "Plain Docker").
#
# Aislamiento:
#   - fs/procesos: contenedor; solo se monta $PWD en /workspace (rw) y el
#     volumen pi-agent-home con la config minima de Pi.
#   - capacidades: --cap-drop=ALL, no-new-privileges, limites de pids/memoria.
#   - red: --network host (OmniRoute :20128 y SearXNG :8888 escuchan en
#     127.0.0.1 del host). Trade-off asumido: sin aislamiento de red.
# Las credenciales y el resto del home del host NO se montan.
#
# Uso:
#   cd ~/nixos-config && ./pi-docker/pi-sandbox.sh          # interactivo
#   ./pi-docker/pi-sandbox.sh -p "lista tareas pendientes"  # no interactivo
#
# Re-siembra (tras cambiar config de Pi en el host):
#   docker volume rm pi-agent-home && ./pi-docker/pi-sandbox.sh
set -euo pipefail

IMAGE="pi-sandbox"
VOLUME="pi-agent-home"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Flags de hardening aplicados a TODAS las ejecuciones del contenedor
HARDENING=(
  --cap-drop=ALL
  --security-opt=no-new-privileges
  --pids-limit=512
  --memory=4g
)

# 1. Construir la imagen si no existe
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "[pi-sandbox] Construyendo imagen $IMAGE..."
  docker build -t "$IMAGE" -f "$HERE/Dockerfile.pi" "$HERE"
fi

# 2. Sembrar el volumen con la config minima de Pi (solo la primera vez).
#    Se copian los archivos SIN mostrarlos (pueden contener endpoints/tokens).
if ! docker volume inspect "$VOLUME" >/dev/null 2>&1; then
  echo "[pi-sandbox] Inicializando volumen $VOLUME con config minima..."
  docker volume create "$VOLUME" >/dev/null
  # La siembra corre SIN --cap-drop: necesita CAP_DAC_OVERRIDE para leer
  # archivos privados del host (auth.json mode 600). Es un proceso de un
  # segundo con el home montado solo-lectura; no ejecuta codigo del modelo.
  docker run --rm \
    --network host \
    -v "$VOLUME":/dst \
    -v "$HOME/.pi/agent":/src:ro \
    -v "$HERE/seed-pi-config.sh":/opt/seed-pi-config.sh:ro \
    --entrypoint bash "$IMAGE" /opt/seed-pi-config.sh
  # Instalar los paquetes npm declarados en settings.json dentro del contenedor
  docker run --rm "${HARDENING[@]}" --network host \
    -v "$VOLUME":/root/.pi/agent \
    --entrypoint pi "$IMAGE" update --extensions
fi

# 3. Ejecutar Pi con red del host (para alcanzar 127.0.0.1:20128 y :8888).
# -it solo si hay TTY (permite uso no interactivo: -p "...", pipes, scripts)
TTY_FLAGS=()
[ -t 0 ] && [ -t 1 ] && TTY_FLAGS=(-it)
exec docker run --rm "${TTY_FLAGS[@]}" "${HARDENING[@]}" \
  --network host \
  -e TERM \
  -v "$PWD:/workspace" \
  -v "$VOLUME":/root/.pi/agent \
  "$IMAGE" "$@"
