---
name: secure-code-practices
description: Good coding practices, code-smell avoidance, and least-privilege design. Load when writing or refactoring non-trivial code, designing modules, or doing code review in any language.
---

# Secure & clean code practices

## Code smells to avoid

- Duplicated logic (copy-paste) instead of shared functions/modules
- Long functions (>~40 lines) doing multiple things; deep nesting (>3 levels)
- Magic numbers/strings instead of named constants
- Mutable global state; hidden side effects in functions that look pure
- Overly broad `catch` blocks that swallow errors silently
- Dead code, commented-out code, unused imports/variables
- Primitive obsession where a small type/record would express intent
- Flag arguments that change behavior instead of separate functions
- Premature abstraction (speculative generality) — three similar lines beat a wrong abstraction

## Practices to apply

- Single responsibility: each function/module does one thing well
- Fail fast and loudly: validate inputs at boundaries, return explicit errors
- Immutability by default; minimize mutable state and variable scope
- Write code for the reader: clear names over comments; comments explain *why*, not *what*
- Keep the diff minimal and reviewable; do not refactor unrelated code in the same change
- Add or update tests for behavior changes; run existing tests before finishing

## Least privilege

- Request the minimum permissions, scopes, and filesystem access the task needs
- Prefer read-only operations first; escalate to write/execute only when required
- Narrow file permissions (chmod 600 for secrets/configs, never 777)
- Narrow network exposure: bind to loopback unless external access is required
- Scope environment variables and tokens to the minimum lifetime and audience
