# tareas.md — Tareas

## Pendientes (requieren acción del usuario)

- [x] ~~`nrs` para aplicar: Pi 1.3.0 + entorno C#/PostgreSQL~~ HECHO
      (2026-10-20, switch limpio; segundo intento tras fixes de podman/HM).
      Verificado: pi 1.3.0, dotnet SDK 10.0.401, dotnet-ef, csharpier, Rider,
      dbeaver y psql en PATH; podman-postgres/omniroute y HM activos;
      conexión psql OK (PostgreSQL 18.6 alpine).
- [ ] Rebuild de la imagen Docker con `pi-coding-agent@1.3.0` y re-siembra
      del volumen (`docker volume rm pi-agent-home && ./pi-docker/pi-sandbox.sh`).

## Entorno de desarrollo C# + PostgreSQL (sesión)

- `modules/user/development.nix`: SDK .NET 10 LTS (`sdk_10_0`, 10.0.401),
      `dotnet-ef` 10.0.9, `csharpier` 1.3.0, Rider 2026.2 (unfree OK por
      allowUnfree), `dbeaver-bin` 26.2.2 (para futuros gestores), cliente
      `psql` (postgresql 18.6, misma versión que el contenedor).
      Telemetría dotnet desactivada (`DOTNET_CLI_TELEMETRY_OPTOUT=1`).
- `modules/system/docker.nix`: contenedor OCI declarativo `postgres`
      (`docker.io/library/postgres:18.6-alpine` pineada, `127.0.0.1:5432` —
      solo localhost, volumen nombrado `postgres-data`, credenciales dev).
      Connection string:
      `Host=127.0.0.1;Port=5432;Username=dev;Password=dev;Database=dev`
- Todo construido y verificado: `nix build` de cada paquete OK y
      `nix flake check --no-build` OK.
- `nix-ld` ya habilitado cubre binarios propietarios que descarga NuGet
      (testhost, etc.).

### Fixes tras el primer switch fallido (podman + HM clobber)

- Descubrimiento: el backend oci-containers resuelto es **podman** (no
      docker; unidades `podman-*`). Podman exige imágenes fully-qualified
      → imagen cambiada a `docker.io/library/postgres:18.6-alpine`.
- PG18: verificada la imagen contra el registry — cambió el layout
      (`VOLUME /var/lib/postgresql`, `PGDATA=/var/lib/postgresql/18/docker`).
      El mount se corrigió a `/var/lib/postgresql`; el original
      (`/var/lib/postgresql/data`) no habría persistido la BD.
- HM falló con "would be clobbered" por `10-hm-fonts.conf` huérfano →
      añadido `home-manager.backupFileExtension = "backup"` en flake.nix
      (HM mueve a *.backup en vez de abortar; fix durable).
- Caveat latente: omniroute usa imagen short-name (`diegosouzapw/...`);
      funciona porque la imagen ya está local. Si se borra el storage de
      podman, calificar a `docker.io/diegosouzapw/omniroute:latest`.
- Reset del volumen (backend podman): `sudo podman volume rm postgres-data`.

## Actualización a Pi 1.3.0 (sesión)

- Flake pineado al tag `github:earendil-works/pi/v1.3.0`.
- Eliminado el override `doInstallCheck = false`: el bug upstream #10881
  (check exigía `esbuild`) está corregido en 1.3.0; build verificado sin
  override (`nix build .#nixosConfigurations.laptop.pkgs.pi` OK).
- Changelog 1.3.0 revisado: sin breaking changes para este setup (afectan
  solo a overrides de base URL de `kimi-coding` en models.json; no usado).
- `pi-web-access` 0.40.0 → 0.43.0 (pi.nix; diff upstream revisado: 15
  commits aditivos, nuevo proveedor xai-search + tests).
- `permission-gate.ts` sin cambios upstream → copia local sigue válida.
- Subagent: solo cambió `index.ts` (helper `formatReadLineRange`, cosmético);
  copia local era idéntica a v1.2.0 oficial → reemplazada por v1.3.0.
- Dockerfile.pi: `@earendil-works/pi-coding-agent@1.2.0` → `@1.3.0`.

## Actualización a Pi 1.2.0 (sesión)

- Flake pineado al tag `github:earendil-works/pi/v1.2.0` (no a main: main
  tiene un error TS conocido en `kimi-coding.ts` a medio migrar).
- Override local `doInstallCheck = false` en flake.nix: el check del tag
  v1.2.0 exige `esbuild` que el install-lock no incluye (bug upstream
  cerrado en #10881; eliminar el override al subir de versión y probar).
- `pi-web-access` 0.38.0 → 0.40.0 (pi.nix + npm del host).
- Imagen Docker reconstruida con `pi-coding-agent@1.2.0` y volumen
  re-sembrado. Smoke tests: host y sandbox OK.
- Al actualizar Pi: revisar ejemplos oficiales copiados (subagent) y el
  changelog antes de subir versiones pineadas.

## Notas de la sesión

- Fix post-rebuild: rutas relativas de `home.file` corregidas a
  `../../pi-config/`; archivos nuevos stageados (los flakes solo ven
  archivos trackeados/stageados por git).
- Home Manager 26.x instala los `home.file` como copias gestionadas
  (mecanismo "putter"), no symlinks clásicos: edita siempre `pi-config/`
  y haz switch para aplicar.

## Completadas (2025- sesión de configuración de Pi)

- [x] Leer contexto del repo (git log, módulos) y documentación oficial de Pi
      (containerization, security, skills, packages).
- [x] Revisar código fuente de `pi-web-access` (tercero) antes de instalar.
- [x] `pi install npm:pi-web-access` + `~/.pi/agent/web-search.json`
      (SearXNG `http://127.0.0.1:8888`, keyless).
- [x] Declarar `npm:pi-web-access` en `modules/user/pi.nix`.
- [x] Subagentes: ejemplo oficial copiado a `~/.pi/agent/extensions/subagent`,
      agentes en `~/.pi/agent/agents`, prompts en `~/.pi/agent/prompts`.
- [x] Skills globales: `owasp-web-security`, `owasp-llm-agentic-security`,
      `secure-code-practices`, `official-docs-first`.
- [x] Docker: `pi-docker/Dockerfile.pi`, `pi-docker/pi-sandbox.sh`,
      `pi-docker/seed-pi-config.sh`; imagen `pi-sandbox` construida y volumen
      `pi-agent-home` sembrado; smoke test del modelo OK (`SANDBOX_OK`).
- [x] Crear `AGENTS.md`, `plan.md`, `tareas.md`.
- [x] Hardening del sandbox: `--cap-drop=ALL`, `no-new-privileges`,
      `--pids-limit=512`, `--memory=4g` (la siembra corre sin cap-drop porque
      necesita leer auth.json mode 600 del host; documentado en el script).
- [x] Pinear versiones: base `node:24-bookworm-slim@sha256:d6aa...`,
      `pi-coding-agent@1.1.0` en la imagen, `pi-web-access@0.38.0` en pi.nix.
- [x] Mover skills al repo (`pi-config/skills/`) como fuente de verdad + creación
      de `pi-config/extensions/permission-gate.ts` (ejemplo oficial adaptado:
      bloquea nixos-rebuild, home-manager switch, git push -f, rm -rf, sudo...).
- [x] Extender siembra del sandbox: ahora copia extensions/, skills/, agents/,
      prompts/ (con `-L` para materializar symlinks del nix store).
- [x] `-it` condicional en pi-sandbox.sh (soporta uso no interactivo).
- [x] Re-siembra completa y smoke test final: `SANDBOX_OK`; permission-gate
      cargado sin errores en el host.
