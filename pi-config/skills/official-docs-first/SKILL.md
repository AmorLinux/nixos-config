---
name: official-docs-first
description: Whenever unsure about an API, option, flag, package, or behavior, consult official documentation before inventing. Use for NixOS, Home Manager, libraries, frameworks, CLI tools, and any claim you are not certain about.
---

# Official documentation first

When you are not certain about something, **do not guess**. Verify against the official source.

## Procedure

1. Identify the canonical source: NixOS manual/options search (`search.nixos.org`), Home Manager options, man pages, official project docs/GitHub, RFCs.
2. Fetch it with the web tools (web_search / web_fetch via pi-web-access, SearXNG local endpoint) or read local docs in the Nix store (`/nix/store/*-pi-*/.../docs` for Pi itself).
3. Cite what the docs say in your answer; state when something could not be verified.
4. If docs conflict with your assumption, the docs win.

## Hard rules

- Never invent command flags, config keys, option names, or API signatures. If unsure, look them up or say you don't know.
- For NixOS/Home Manager options, verify the exact option path exists before writing it (e.g. `nixi`/`nix search` not enough for options — check `search.nixos.org` or `man configuration.nix`).
- When the user explicitly says "I prefer X but verify", verify X against docs before implementing.
