# GSDD Method
## Governed Specification-Driven Development

---

## 1. Purpose

This document defines **how the GSDD method operates as a system**.

It describes:
- how governance and execution interact
- how authority flows
- how correctness is enforced
- how failures are handled

This document does NOT define tools or implementations.
It defines **method behavior**.

---

## 2. Method Overview

GSDD operates on a single invariant:

> **Execution is not a default. Execution is granted.**

Every execution is treated as a **governed transaction** that must:
- be explicitly authorized
- be fully constrained
- produce a verifiable outcome
- terminate cleanly

---

## 3. Core Method Pillars

The GSDD method is built on the following pillars:

### 3.1 Specification as Authority

- No execution exists without a SPEC
- The SPEC is the single source of truth
- The SPEC constrains scope, inputs, and outcome
- The SPEC is immutable once execution is authorized

---

### 3.2 Role Separation

GSDD enforces **logical separation** between:

- **Governance Role**
- **Execution Role**

The same agent MAY embody both roles, but:
- roles MUST be logically isolated
- authority transitions MUST be explicit
- execution MUST NOT influence governance

---

### 3.3 Deterministic Context

Each execution operates on a **deterministic context snapshot**.

- Context is loaded intentionally
- Context is bounded
- Context is disposable

Implicit or accumulated context is forbidden.

---

### 3.4 Atomicity and Isolation

Each execution enforces:

> **1 SPEC = 1 scope = 1 execution = 1 outcome**

Executions are isolated.
No shared state, no continuation, no chaining.

---

### 3.5 Auditability

Every execution MUST be:
- auditable
- reproducible
- verifiable against the SPEC

Perceived correctness is irrelevant.
Only audited correctness matters.

---

## 4. Method Lifecycle

The GSDD method operates through a fixed lifecycle:

1. Governance phase
2. Authorization
3. Execution
4. Audit
5. Termination

No lifecycle step may be skipped, merged, or bypassed.

---

## 5. Governance Phase

The governance phase is responsible for:

- validating the SPEC
- resolving ambiguity
- enforcing architectural boundaries
- deciding whether execution is allowed

Possible outcomes:
- **Authorize execution**
- **STOP**

STOP is a valid and successful result.

---

## 6. Authorization Boundary

Authorization is a **hard boundary**.

Before authorization:
- no execution is allowed
- no side effects are permitted

After authorization:
- execution authority is granted
- governance rules remain enforceable
- scope becomes immutable

Authorization MUST be explicit.

---

## 7. Execution Phase

Execution MUST:

- follow the SPEC exactly
- remain within declared scope
- respect architectural boundaries
- stop immediately on deviation

Execution MUST NOT:
- reinterpret intent
- expand scope
- correct the SPEC
- continue under ambiguity

---

## 8. Audit Phase

Audit occurs **after execution and before commit**.

Audit verifies:
- SPEC compliance
- architectural integrity
- isolation guarantees
- outcome correctness

Audit outcomes:
- **PASS → commit allowed**
- **FAIL → ABORT**

Audit is non-negotiable.

---

## 9. Failure Handling

GSDD defines two valid failure modes:

### 9.1 STOP (Pre-execution)

Occurs when:
- SPEC is missing or invalid
- ambiguity exists
- governance validation fails

STOP prevents execution.

---

### 9.2 ABORT (Post-execution)

Occurs when:
- execution violates the SPEC
- audit fails
- architectural boundaries are crossed

ABORT terminates execution immediately.

---

## 10. No Auto-Healing Rule

GSDD forbids auto-healing within an execution.

Failures MUST NOT be:
- silently corrected
- retried
- continued

Correction is only allowed as:
- a new SPEC
- a new execution
- a new outcome

---

## 11. Termination

Termination ends all authority for the execution.

After termination:
- execution cannot continue
- execution cannot be modified
- execution cannot be resumed

New work requires a new lifecycle.

---

## 12. Determinism Over Convenience

When faced with ambiguity, uncertainty, or incomplete information:

> **The method stops.**

Convenience, speed, or perceived simplicity never justify execution.

---

## 13. Method Guarantees

When followed correctly, the GSDD method guarantees:

- zero scope bleed
- deterministic execution
- explicit failure
- audit-ready outcomes
- conflict-free parallel work

---

## 14. Method Neutrality

GSDD is neutral to:
- tools
- languages
- platforms
- AI models
- workflows

Any implementation that complies with this method is valid.

---

## 15. Final Principle

> **Correctness without governance is failure.**

The GSDD method optimizes for system integrity, not speed.

---