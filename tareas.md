# tareas.md — Tareas

## Pendientes (requieren acción del usuario)

- [ ] `nrs` para instalar Pi 1.2.0 en el perfil (ya construido y probado).
- [ ] Probar `pi-docker/pi-sandbox.sh` interactivamente.

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
