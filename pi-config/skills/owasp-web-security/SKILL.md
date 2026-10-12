---
name: owasp-web-security
description: Apply the OWASP Top 10 (web) when writing, reviewing, or auditing web application code, APIs, auth flows, or configuration. Use whenever a task touches HTTP endpoints, user input, sessions, tokens, or access control.
---

# OWASP Top 10 (Web) checklist

When creating or reviewing web code and configuration, check every change against the current OWASP Top 10 categories:

1. **Broken Access Control** – enforce authorization server-side on every request; deny by default; never trust client-supplied roles/IDs (IDOR).
2. **Cryptographic Failures** – no secrets in code/logs; use strong modern algorithms (Argon2/bcrypt for passwords, TLS 1.2+ in transit); never roll your own crypto.
3. **Injection** – parameterize all queries; never concatenate user input into SQL, shell commands, LDAP, or templates; validate and encode output by context.
4. **Insecure Design** – threat-model new features; least privilege by default; fail closed.
5. **Security Misconfiguration** – remove debug/defaults in production; minimal headers and surface area; keep dependencies patched.
6. **Vulnerable & Outdated Components** – pin versions, check advisories before adding a dependency; prefer maintained, minimal packages.
7. **Identification & Authentication Failures** – rate-limit auth endpoints; secure session management (HttpOnly/Secure/SameSite cookies, rotation); no credential leaks in logs.
8. **Software & Data Integrity Failures** – verify integrity of dependencies/updates; treat CI/CD and deserialization as untrusted-input boundaries.
9. **Security Logging & Monitoring Failures** – log authz/authn failures and suspicious input without leaking secrets; make logs tamper-resistant.
10. **SSRF** – allowlist outbound destinations; block link-local/metadata ranges; validate and normalize URLs before fetching.

Apply as: a checklist in every code review, a threat checklist for new endpoints, and explicit notes in the final summary of what was checked and what remains a risk.
