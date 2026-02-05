# GSDD Method — Conceptual Reference

## Purpose

This directory defines the **conceptual foundation** of the GSDD method.

It explains *what the method guarantees*, *what it intentionally does not*,  
and *how trust, assurance, and governance are reasoned about* — **without**
describing operational mechanisms or enforcement details.

This section is **authoritative in intent, but non-operational by design**.

---

## Scope and Authority

The documents in this directory:

- describe **properties**, not implementations
- define **boundaries**, not procedures
- explain **guarantees**, not tools

They are intended for:
- architects
- governance owners
- auditors
- technical leadership

They are **not** tutorials or how-to guides.  
They MUST NOT be used as a basis for implementation decisions without reference to the normative documents.

---

## Relationship to Normative Documents

This directory does **not** override normative rules.

In case of conflict, the following documents always take precedence:

- `gsdd_core.md` — the law
- `rules.md` — enforceable constraints
- `execution_flow.md` — mandatory sequence
- `spec_contract.md` — execution contract

This directory exists to **explain and contextualize**, not to govern.

---

## Conceptual Domains

### Assurance
Defines the post-execution confidence model:
- what can be verified
- what is guaranteed
- what is explicitly not guaranteed

### Auditability
Explains how executions can be evaluated against governance rules
without relying on subjective judgment.

### Traceability
Describes how execution artifacts relate across time and context,
without creating global coupling.

### Integrity
Defines immutability as an evidence property, not as a security claim.

---

## Security and Abuse Considerations

This directory intentionally avoids:

- algorithm descriptions
- attack scenarios
- bypass examples
- enforcement internals

All explanations are **property-based**, not mechanism-based.

This is a deliberate design choice to prevent misuse and reverse engineering.  
Any use of these documents to infer or construct attack paths is explicitly outside the intended scope of the method.

---

## Stability and Evolution

The method evolves cautiously.

Changes to conceptual guarantees:
- are rare
- require explicit governance review
- never retroactively redefine past executions

Stability is a core property of the GSDD method.

---

## Final Note

The GSDD method is not defined by tools or scripts.

It is defined by **governed limits**, **explicit guarantees**, and  
**evidence-based accountability**.

This directory exists to make those limits understandable —  
without weakening them.

> This section describes properties, boundaries, and guarantees.  
> It intentionally avoids operational detail, algorithms, or enforcement mechanisms.