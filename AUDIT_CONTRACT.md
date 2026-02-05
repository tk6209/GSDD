# GSDD Audit Contract (Normative)

## Purpose

Audit in GSDD exists to **verify outcomes**, not to improve them.

Audit is **not execution**.  
Audit is **not correction**.

---

## What Audit MAY Do

An audit MAY:

- verify outcome against the declared SPEC
- check compliance with constraints
- confirm scope containment
- validate that execution boundaries were respected

Audit answers one question only:

> Does the outcome satisfy the SPEC?

---

## What Audit MUST NOT Do

An audit MUST NOT:

- modify code
- modify the SPEC
- suggest fixes to pass validation
- auto-heal execution
- reinterpret intent

If the outcome does not satisfy the SPEC:

> The execution is invalid and MUST be aborted.

---

## Relationship to Execution Flow

Audit occurs:

- after execution
- before commit

A commit is **forbidden** without a successful audit.

Audit failure is **not an error**.  
It is a valid and expected outcome.

---

## Final Rule

> In GSDD, nothing is fixed.
> Executions either pass or terminate.

This contract is normative.
