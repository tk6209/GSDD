# SECURITY_POLICY — GSDD

## Purpose

This document defines the **normative security acceptance criteria** for systems developed or modified under the **GSDD (Governed Specification-Driven Development)** method.

It establishes **what must be verified** for an execution outcome to be considered **security-acceptable**.

This policy:
- does NOT define implementation steps
- does NOT prescribe tooling
- does NOT authorize automated remediation
- does NOT grant security guarantees by default

Security is treated as an **audit property**, not an execution feature.

---

## Scope

This policy applies to:

- all execution outcomes produced under GSDD
- all code changes subject to acceptance, release, or deployment
- all systems where security posture is a concern (default: yes)

This policy is **transversal** and independent of:
- programming language
- framework
- infrastructure
- AI model or tooling

---

## Normative Position

Under GSDD:

> **Security is never assumed.  
> Security is only accepted after audit.**

An execution outcome that fails any mandatory security criterion
**MUST be rejected**, regardless of functional correctness.

---

## Relationship to Other GSDD Documents

In case of conflict, the following precedence applies:

1. `gsdd_core.md` — execution law
2. `execution_flow.md` — mandatory sequence
3. `spec_contract.md` — execution contract
4. `AUDIT_CONTRACT.md` — audit rules
5. `SECURITY_POLICY.md` — security acceptance criteria

This document **does not override** governance rules.
It complements them.

---

## Security Model

### Explicit, Not Implicit

Security requirements MUST be:
- explicitly declared in the SPEC, **or**
- explicitly evaluated during audit

Implicit security assumptions are forbidden.

---

### No Auto-Healing Principle

Security issues:
- MUST NOT be auto-fixed
- MUST NOT be silently mitigated
- MUST NOT trigger corrective execution automatically

Any correction requires:
- a new SPEC
- a new governed execution cycle

---

## OWASP-Aligned Risk Categories (Normative)

The following categories define **mandatory security audit lenses**.

This list is inspired by OWASP Top 10, but expressed as **audit criteria**, not implementation guidance.

---

### 1. Access Control

The outcome MUST NOT:

- expose unauthorized access paths
- bypass authentication or authorization checks
- allow privilege escalation
- weaken role or tenant isolation

Access control violations are **critical failures**.

---

### 2. Authentication & Identity Handling

The outcome MUST NOT:

- introduce insecure authentication flows
- leak credentials, tokens, or secrets
- weaken identity verification guarantees

Identity handling MUST be explicit and auditable.

---

### 3. Data Protection

The outcome MUST NOT:

- expose sensitive data unintentionally
- log secrets or personal data
- downgrade encryption or protection mechanisms

Data sensitivity MUST be respected according to system context.

---

### 4. Injection & Input Handling

The outcome MUST NOT:

- introduce injection vectors (SQL, command, template, etc.)
- trust unsanitized external input
- weaken existing input validation boundaries

Assumed sanitization is invalid.

---

### 5. Insecure Configuration

The outcome MUST NOT:

- introduce insecure defaults
- disable security checks for convenience
- expose debug, test, or admin functionality unintentionally

Configuration changes MUST be intentional and reviewable.

---

### 6. Dependency & Supply Chain Risk

The outcome MUST NOT:

- introduce unreviewed dependencies
- downgrade security-relevant versions
- bypass dependency integrity controls

Dependency changes MUST be explicit in the SPEC.

---

### 7. Error Handling & Information Exposure

The outcome MUST NOT:

- leak internal system details through errors
- expose stack traces or sensitive metadata
- convert failures into silent success

Failures must be explicit and controlled.

---

### 8. Logging & Observability Safety

The outcome MUST NOT:

- log sensitive information
- create logs that bypass access controls
- introduce uncontrolled observability endpoints

Logs are evidence, not leakage vectors.

---

### 9. Isolation & Boundary Integrity

The outcome MUST NOT:

- blur domain boundaries
- bypass architectural isolation
- allow cross-context data flow without authorization

This criterion directly enforces **“The Wall”**.

---

### 10. Security Regression

The outcome MUST NOT:

- reduce previously established security guarantees
- remove controls without explicit authorization
- weaken protections to “make things work”

Regression is a failure, not a trade-off.

---

## Audit Requirements

Security acceptance requires:

- explicit evaluation against this policy
- documented audit decision (accept / reject)
- zero unresolved critical findings

Subjective judgment is insufficient.

---

## Failure Handling

If any security criterion is violated:

- the execution outcome MUST be rejected
- no commit or release is allowed
- a new SPEC is required for correction

Security failure is a **governance success**, not a defect.

---

## Non-Goals

This policy intentionally does NOT:

- prescribe secure coding techniques
- define implementation patterns
- automate security enforcement
- replace security teams or reviews

It defines **acceptance boundaries**, not solutions.

---

## Final Principle

> **Security under GSDD is not achieved by tools.  
> It is achieved by explicit limits, auditable outcomes, and disciplined rejection.**

No execution is secure by default.  
Security exists only where it is proven and accepted.

---

## Status

- Type: Normative policy
- Scope: Transversal
- Automation: None
- Enforcement: Audit-only
- Compatibility: Enterprise / Regulated environments

## Execution Interaction

This policy does NOT participate in the execution flow.

- It MUST NOT block execution.
- It MUST NOT be evaluated implicitly.
- It MUST NOT run unless explicitly requested.

Security evaluation under GSDD is:
- optional
- explicit
- audit-only

Execution remains governed exclusively by:
- gsdd_core.md
- execution_flow.md
- spec_contract.md