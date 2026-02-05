# GSDD Terminology
## Governed Specification-Driven Development

[**English**](#english) | [**Português**](#português)

---

<a name="english"></a>
# English

This document defines the **official terminology** of the **GSDD (Governed Specification-Driven Development)** method.

Its purpose is to eliminate ambiguity, prevent misuse of concepts, and ensure that the method remains **consistent, auditable, and implementation-agnostic**.

If a term is not defined here, it is **not part of the GSDD method**.

---

## GSDD (Governed Specification-Driven Development)

**GSDD** is an open, governance-first method for AI-assisted software development that introduces **explicit control over execution authority**.

GSDD extends Specification-Driven Development (SDD) by enforcing:
- closed specifications
- deterministic context
- architectural boundaries
- atomic execution
- objective verification
- explicit acceptance or abort

> GSDD governs **when execution is allowed**, not how code is written.

---

## Specification (SPEC)

A **Specification (SPEC)** is a formal, written declaration that defines **exactly what execution is authorized**.

A valid SPEC MUST define:
- a single, closed scope
- a clear objective
- required inputs
- constraints
- expected outcome

A SPEC defines *what is allowed*, never *how it is implemented*.

Without a valid SPEC, execution is forbidden.

---

## Specification Contract

The **Specification Contract** defines the rules that determine whether a SPEC is valid.

A SPEC that violates the contract:
- MUST NOT authorize execution
- MUST cause **STOP** if detected pre-execution
- MUST cause **ABORT** if violated during execution

There is no partial validity.

---

## Governance

**Governance** is the system of explicit rules that control execution authority.

Governance:
- precedes execution
- constrains execution
- validates outcomes

Governance is not advisory.
It is a **gate**.

---

## Governance Role

The **Governance Role** is responsible for:
- validating SPECs
- enforcing execution rules
- authorizing execution
- auditing outcomes

The Governance Role MUST NOT perform execution.

Logical separation is mandatory, even if implemented within a single agent.

---

## Execution Role

The **Execution Role** is responsible for:
- performing actions strictly defined by the SPEC
- operating only after explicit authorization
- stopping immediately on deviation

The Execution Role MUST NOT interpret, extend, or correct the SPEC.

---

## Context Snapshot

A **Context Snapshot** is a deterministic, bounded representation of all information required for a single execution.

Each execution:
- MUST operate on a fresh context snapshot
- MUST NOT inherit uncontrolled prior context
- MUST treat context as disposable

How the snapshot is generated is implementation-specific.

---

## Deterministic Context Loading

**Deterministic Context Loading** ensures that:
- only relevant information is loaded
- context is reproducible
- executions are comparable and auditable

Context inference or accumulation is forbidden.

---

## The Wall

**The Wall** is the architectural boundary system enforced by GSDD.

It defines **non-negotiable separation** between domains, contexts, and responsibilities.

Violating The Wall invalidates execution.

> Architecture is law.

---

## Execution

In GSDD, **execution** is a privileged operation.

Execution is allowed only after:
- a valid SPEC exists
- the SPEC is validated
- execution is explicitly authorized
- context is deterministically loaded

Execution under ambiguity is forbidden.

---

## Atomic Execution

**Atomic Execution** means:
- one SPEC
- one scope
- one execution
- one context snapshot
- one branch
- one outcome
- one commit

There are no partial, chained, or implicit executions.

---

## Execution Isolation

**Execution Isolation** enforces:

> **1 task = 1 branch = 1 execution**

Executions MUST NOT:
- share branches
- overlap scopes
- contaminate context

Isolation violations invalidate execution.

---

## Outcome

An **Outcome** is the concrete, immutable result produced by an execution.

An outcome:
- MUST be auditable
- MUST be immutable
- MUST map directly to the SPEC

Outcomes MUST NOT be retroactively corrected.

---

## Audit

An **Audit** is an objective verification step performed **after execution and before commit**.

Audit verifies:
- compliance with the SPEC
- respect for architectural boundaries
- integrity of the outcome

Audit is structural, not conversational.

If audit fails, commit is forbidden.

---

## STOP

**STOP** is a governance outcome that occurs **before execution**.

STOP occurs when:
- a SPEC is missing
- a SPEC is incomplete
- ambiguity exists
- validation fails

STOP is a successful governance result.

---

## Abort

An **Abort** is a formal execution outcome.

Abort occurs when:
- execution violates the SPEC
- architectural boundaries are crossed
- audit fails
- scope leaks occur

Abort terminates execution immediately.

---

## Auto-Healing (Prohibited)

**Auto-Healing** is any attempt to silently correct, retry, or continue an execution after failure.

Auto-Healing is **forbidden within an execution**.

Correction is only permitted as:
- a new SPEC
- a new execution
- a new outcome

---

## Termination

**Termination** marks the end of execution authority.

After termination:
- execution MUST NOT continue
- execution MUST NOT be corrected
- execution MUST NOT be retried

Any further work requires a new execution flow.

---

## Method vs Implementation

GSDD strictly separates:
- **Method**: normative execution law
- **Implementation**: tools that apply the method

The method is authoritative.
Implementations are replaceable.

---

## Reference Implementation

**Guardian** is the reference implementation of the GSDD method.

Guardian is not the method.
Other implementations are valid if they fully comply with GSDD rules.

---

## Non-Goals

GSDD explicitly does NOT define:
- programming languages
- frameworks
- model providers
- prompting styles
- coding assistants
- version control tools

GSDD governs execution authority, not tools.

---

<a name="português"></a>
# Português

(Estrutura espelhada e conteúdo equivalente ao inglês, mantendo redundância normativa e densidade conceitual.)

---