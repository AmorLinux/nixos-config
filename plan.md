# plan.md — Plan de alto nivel

## Objetivo actual

Tener Pi Coding Agent configurado de forma segura, mantenible y declarativa
para trabajar sobre esta config de NixOS:

1. Contexto leído antes de actuar (md + git log) ✔
2. Aislamiento con Docker (patrón oficial "Plain Docker") ✔
3. Web search + fetch de documentación oficial (pi-web-access + SearXNG local) ✔
4. Subagentes (ejemplo oficial de Pi) ✔
5. Skills: OWASP web, OWASP LLM/agentic, buenas prácticas, docs-oficiales-primero ✔
6. Paquetes declarativos en `modules/user/pi.nix` ✔

## Siguientes mejoras posibles (no empezadas)

- Evaluar Docker Sandboxes u OpenShell para aislamiento también de red.
- Evaluar Gentle Shell o permisos más finos si el modelo local madura.
- Añadir skill específica de NixOS (patrones comunes de módulos) si se repite trabajo.
