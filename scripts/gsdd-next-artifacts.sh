#!/usr/bin/env bash
set -euo pipefail

echo "🛡️ GSDD NEXT — Creating normative & educational artifacts"
echo

# Guardrail
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "ERROR: Working tree not clean. Commit or stash first."
  exit 1
fi

# -------------------------------------------------------------------
# 1️⃣ ROADMAP.md
# -------------------------------------------------------------------

echo "📍 Creating ROADMAP.md"

cat > ROADMAP.md <<'DOC'
# GSDD Roadmap

This roadmap defines the **governed evolution** of the GSDD method.

Dates are intentionally omitted.  
Progress is gated by **semantic readiness**, not velocity.

---

## v0.2.0 — Audit Contract

Focus:
- Define what *audit means* in GSDD
- No tooling, no automation

Deliverables:
- Normative audit contract
- Audit boundaries and prohibitions
- Clear separation between execution and verification

---

## v0.3.0 — Evidence & Snapshot Semantics

Focus:
- Evidence, not correction
- Traceability without coupling

Deliverables:
- Snapshot artifact schema
- Execution ledger semantics
- Immutable evidence model

---

## v1.0.0 — Stable Open Method

Exit criteria:
- Method semantically closed
- CLI minimal and stable
- No implicit behavior
- External adoption validated

---

GSDD evolves by **tightening limits**, not by adding features.
DOC

# -------------------------------------------------------------------
# 2️⃣ AUDIT CONTRACT (NORMATIVE, NO CODE)
# -------------------------------------------------------------------

echo "📜 Creating AUDIT_CONTRACT.md"

cat > AUDIT_CONTRACT.md <<'DOC'
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
DOC

# -------------------------------------------------------------------
# 4️⃣ EXAMPLES (EDUCATIONAL)
# -------------------------------------------------------------------

echo "📚 Creating examples/"

mkdir -p examples

cat > examples/spec-invalid.md <<'DOC'
# GSDD SPEC — Invalid Example

## Scope
Implement authentication.

## Objective
Improve login.

## Expected Outcome
It works.

# ❌ INVALID:
# - Scope is not bounded
# - Inputs are missing
# - Constraints are missing
# - Outcome is not verifiable
DOC

cat > examples/spec-valid.md <<'DOC'
# GSDD SPEC — Valid Example

## Scope
Add email + password login to the web application.

## Objective
Allow registered users to authenticate using email and password.

## Inputs
- Email (string)
- Password (string)

## Constraints
- No changes outside the auth module
- No UI redesign
- No new dependencies

## Expected Outcome
- User can log in with valid credentials
- Invalid credentials are rejected
- Existing tests continue to pass
DOC

# -------------------------------------------------------------------
# Commit
# -------------------------------------------------------------------

git add ROADMAP.md AUDIT_CONTRACT.md examples
git commit -m "docs: add roadmap, audit contract, and governed examples"

echo
echo "✅ GSDD next artifacts created."
