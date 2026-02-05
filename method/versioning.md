# Versioning
## Stability, Evolution, and Backward Integrity in GSDD

---

## 1. Purpose

This document defines the **versioning principles** of the GSDD method.

Versioning in GSDD exists to ensure:

- long-term stability of governed executions
- non-retroactive interpretation of artifacts
- safe evolution of the method without breaking trust

Versioning does **not** describe implementation mechanics.  
It defines **how change is governed**, not how it is executed.

---

## 2. What Is Versioned in GSDD

GSDD versioning applies to **method semantics**, not to tools.

The following elements are versioned:

- conceptual guarantees
- normative rules
- execution boundaries
- specification requirements
- assurance properties

The following elements are explicitly **not** versioned by the method:

- scripts or utilities
- CLIs or SDKs
- automation layers
- infrastructure choices
- agent implementations

Tools may evolve independently.  
The method does not inherit their lifecycle.

---

## 3. Version Authority

Only the following documents define method version authority:

- `gsdd_core.md`
- `rules.md`
- `execution_flow.md`
- `spec_contract.md`

Conceptual documents (including this one) **explain**, but do not override,  
normative authority.

If a conflict exists, **normative documents always prevail**.

---

## 4. Backward Integrity Principle

GSDD enforces **backward integrity**:

> An execution is always interpreted under the rules that were valid  
> at the time it was finalized.

This means:

- past executions are never reinterpreted
- guarantees are never retroactively strengthened or weakened
- invalidating history is forbidden

Version changes apply **only to future executions**.

---

## 5. Semantic Versioning (Conceptual)

GSDD versions are **semantic**, not numeric by default.

A version change indicates a change in **meaning**, not in tooling.

Version evolution may occur when:

- new guarantees are introduced
- existing guarantees are explicitly restricted
- execution boundaries are redefined
- new mandatory governance constraints are added

Version evolution does **not** occur for:

- clarifications
- editorial improvements
- documentation restructuring
- non-normative explanations

---

## 6. Compatibility Classes

Changes to the GSDD method fall into three compatibility classes:

### 6.1 Compatible Changes

- additive guarantees
- stricter validation
- clearer failure conditions
- improved audit clarity

These changes do not invalidate existing artifacts.

---

### 6.2 Restrictive Changes

- removal of previously allowed behaviors
- stricter interpretation of rules
- tighter execution boundaries

Restrictive changes apply **only forward**  
and require explicit version signaling.

---

### 6.3 Breaking Changes

Breaking changes are rare and exceptional.

They include:

- redefining execution validity
- altering the meaning of finalization
- changing the authority model

Breaking changes require:

- explicit governance declaration
- clear version boundary
- non-retroactive enforcement

---

## 7. Version Signaling

Executions MAY declare:

- the method version
- the normative snapshot reference
- the governing rule set identifier

Absence of explicit version signaling does **not** invalidate execution,  
but limits cross-version comparison.

Version signaling is descriptive, not enforcement-based.

---

## 8. Versioning and Assurance

Assurance properties are **version-scoped**.

This means:

- assurance claims are evaluated under the version in effect at execution time
- newer assurance models do not override older evidence
- trust is contextual, not global

Versioning preserves auditability by preventing semantic drift.

---

## 9. Change Governance

Changes to the GSDD method:

- are intentional
- are reviewed
- are documented
- are traceable

Unannounced or implicit changes are forbidden.

Stability is treated as a first-class property of the method.

---

## 10. What Versioning Does NOT Do

For clarity, GSDD versioning does **not** provide:

- migration tooling
- automatic upgrades
- backward enforcement
- reinterpretation of history
- compatibility guarantees across implementations

Versioning governs **meaning**, not execution mechanics.

---

## 11. Final Principle

In GSDD:

> **Versioning exists to protect trust over time.  
> Not to accelerate change.**

A stable method enables reliable governance.

And reliable governance requires that the past  
remains valid — forever.
