# tareas.md — Tareas

## Pendientes (requieren acción del usuario)

- [ ] Probar `pi-docker/pi-sandbox.sh` interactivamente.
- [ ] Commitear los cambios propios pendientes del usuario (flake.nix,
      home.nix, development.nix, flake.lock — ajenos a la config de Pi).

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
