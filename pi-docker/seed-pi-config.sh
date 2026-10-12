#!/usr/bin/env bash
# seed-pi-config.sh — corre DENTRO del contenedor (montado en /opt, solo lectura).
# Copia la config de Pi desde /src (~/.pi/agent del host, ro) a /dst
# (volumen pi-agent-home). -L en cp para materializar symlinks del nix store
# (home-manager enlaza los archivos declarativos hacia /nix/store, que no
# existe dentro del contenedor).
set -e

# Archivos sueltos (pueden contener endpoints/tokens: NO mostrarlos)
for f in settings.json models.json auth.json web-search.json; do
  [ -f "/src/$f" ] && cp -L "/src/$f" "/dst/$f"
done

# Directorios completos: extensiones (subagent, permission-gate, settings de
# pi-omniroute-sync), skills, agentes y prompts de subagentes
for d in extensions skills agents prompts; do
  [ -d "/src/$d" ] && cp -rL "/src/$d" "/dst/$d"
done
