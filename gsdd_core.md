# GSDD — Governed Specification-Driven Development
## Core Principles and Execution Law

---

## 1. Purpose

GSDD defines a governed execution model where **no action is permitted without an explicit, validated specification**.

Its primary goal is to eliminate:
- implicit assumptions
- premature execution
- conversational authority
- uncontrolled scope expansion

Execution is a **privilege**, not a default.

---

## 2. Foundational Principles

### 2.1 Specification First

Execution MUST be preceded by a written specification (SPEC).  
Any execution without an explicit SPEC is invalid.

---

### 2.2 Explicit Over Implicit

Implicit context, inferred intent, or assumed requirements are forbidden.  
All relevant constraints MUST be explicitly declared.

---

### 2.3 Governance Is a Distinct State

Governance and execution are **distinct states**, even if performed by the same agent.

- Governance evaluates, constrains, and authorizes.
- Execution performs strictly what was authorized.

No execution may occur while governance is unresolved.

---

### 2.4 Determinism Over Convenience

When faced with ambiguity, the system MUST stop.  
Convenience, speed, or perceived simplicity never justify execution.

---

### 2.5 Governance Before Output

Producing output without governance is considered a failure, even if the output is technically correct.

---

### 2.6 One Execution, One Scope

Each execution MUST operate on a single, explicitly bounded scope.  
Multi-scope execution is forbidden.

---

### 2.7 Execution Is Finite

Execution is **atomic and terminal**.

Once execution begins:
- it MUST either complete successfully or abort
- it MUST NOT evolve, retry silently, or self-correct

There is no concept of “ongoing execution” under GSDD.

---

## 3. Definition of a Valid Execution

An execution is considered **valid** only if ALL conditions below are met:

1. A SPEC exists and is accessible.
2. The SPEC defines a single, bounded scope.
3. Inputs, constraints, and expected outcomes are explicit.
4. No ambiguity remains unresolved.
5. Execution was explicitly authorized after validation.
6. The outcome was audited against the SPEC before acceptance.

If any condition is unmet, execution is invalid.

---

## 4. Definition of a Prohibited Execution

The following executions are strictly forbidden:

- Execution without a SPEC.
- Execution based on inferred or assumed intent.
- Execution across multiple scopes.
- Execution while ambiguity exists.
- Execution performed “to see what happens”.
- Execution justified by urgency or convenience.
- Execution that mutates its own governing SPEC.

A prohibited execution MUST be aborted immediately.

---

## 5. The Role of the SPEC

The SPEC is the **single source of truth** for execution.

The SPEC:
- defines scope
- defines boundaries
- defines success criteria
- constrains execution

Execution MUST conform to the SPEC.  
The SPEC MUST NOT adapt to execution results.

---

## 6. Ambiguity Handling

Ambiguity is defined as:
- missing information
- conflicting constraints
- unclear scope boundaries
- undefined success criteria

When ambiguity is detected:

- Execution MUST NOT proceed.
- Clarification MUST be requested.
- No speculative resolution is allowed.

Ambiguity resolution is mandatory before execution.

---

## 7. Outcome Auditing

All execution outcomes MUST be audited against the SPEC.

- Audit precedes acceptance.
- Audit failure forbids commit.
- Subjective “looks correct” validation is invalid.

Audit is a **governance requirement**, not an implementation detail.

---

## 8. When to Stop

Execution MUST stop immediately if:

- the SPEC is missing or incomplete
- scope boundaries become unclear
- new requirements emerge mid-execution
- constraints conflict with the SPEC
- execution deviates from declared intent

Stopping is a **successful outcome** under GSDD.

---

## 9. When to Ask Questions

Questions MUST be asked when:

- intent cannot be determined explicitly
- multiple valid interpretations exist
- execution choices affect scope or outcome
- constraints are underspecified

Questions are a governance mechanism, not a failure.

---

## 10. When to Abort

An abort MUST occur when:

- the SPEC cannot be validated
- ambiguity persists after clarification attempts
- execution would violate any core principle
- scope cannot be constrained safely

Aborted executions MUST NOT be partially completed.

---

## 11. Correction and Re-execution

Any correction, fix, or improvement:

- MUST NOT modify an authorized execution
- MUST initiate a new execution cycle
- MUST require a new or updated SPEC

Correction is never a continuation.

---

## 12. Authority and Finality

No execution may override these principles.

No output, result, or perceived correctness justifies violating this core law.

**Governance is absolute.**