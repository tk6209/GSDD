# Integrity

## 1. Purpose

Integrity in GSDD defines the assurance that an execution artifact **has not been altered after it was finalized**.

The goal of integrity is not prevention, deterrence, or enforcement.
Its goal is **evidence**.

Integrity answers a single question:

> *“Is this artifact the same one that was originally produced?”*

---

## 2. Integrity as a Property, Not a Mechanism

GSDD treats integrity as a **verifiable property**, not as an implementation detail.

The method intentionally avoids binding integrity guarantees to:
- specific cryptographic algorithms
- storage systems
- transport layers
- enforcement technologies

This ensures that integrity remains:
- tool-agnostic
- future-proof
- independent of vendor or platform choices

---

## 3. Scope of Integrity

Integrity applies to **execution artifacts**, not to systems or environments.

Specifically:
- generated snapshots
- declared execution outputs
- finalized artifacts produced by a governed execution

Integrity does **not** apply to:
- runtime behavior
- execution environments
- external dependencies
- organizational processes

Those concerns are explicitly out of scope.

---

## 4. Artifact Immutability

Once an execution artifact is finalized:

- its content is considered immutable
- its structure is considered fixed
- its declared metadata is considered authoritative

Any post-finalization modification:
- invalidates integrity
- breaks auditability
- severs traceability continuity

Immutability is logical, not physical.
It is enforced by **governance rules**, not storage constraints.

---

## 5. Finalization Boundary

Integrity is anchored at a clear boundary:

> **Finalization marks the end of execution authority.**

Before finalization:
- artifacts may be incomplete
- content may evolve
- integrity is undefined

After finalization:
- no mutation is permitted
- no correction is allowed
- no continuation is valid

Any change requires a **new execution**.

---

## 6. Evidence of Integrity

GSDD integrity relies on **tamper-evident signals**, not tamper-proof systems.

These signals allow:
- detection of modification
- comparison across copies
- verification against recorded references

Integrity evidence supports:
- audits
- reviews
- forensic analysis

It does not claim to prevent alteration.
It claims to **reveal it**.

---

## 7. Integrity and Governance

Integrity has no meaning outside governance.

Without governance:
- immutability is a convention
- integrity claims are subjective
- evidence lacks authority

Within GSDD:
- integrity is declared
- integrity is bounded
- integrity is auditable

Governance defines *when* integrity begins and *what* it applies to.

---

## 8. Relationship to Auditability and Traceability

Integrity is one of three complementary assurance pillars:

| Pillar | Question Answered |
|------|-------------------|
| Integrity | Has this artifact changed? |
| Auditability | Can this execution be verified? |
| Traceability | How does this relate over time? |

Integrity alone is insufficient.
Combined, they enable confident post-execution reasoning.

---

## 9. What Integrity Does NOT Guarantee

For clarity and legal safety, GSDD integrity does **not** guarantee:

- protection against malicious actors
- prevention of unauthorized access
- enforcement of access control
- cryptographic non-repudiation in the absolute sense
- resistance to all forms of tampering

These concerns belong to security architecture, not execution governance.

---

## 10. Abuse Resistance by Design

GSDD preserves integrity concepts without enabling misuse by:

- avoiding exposure of internal derivation logic
- avoiding step-by-step verification recipes
- avoiding attack or bypass scenarios

Integrity is presented as a **verification capability**, not as a target.

---

## 11. Final Principle

In GSDD:

> **Integrity is not about stopping change.  
> It is about making change undeniable.**

If an artifact must change,
it must be regenerated,
re-governed,
and re-finalized.

There is no other valid path.
