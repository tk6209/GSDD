GSDD Rules
Normative Execution, Architecture, and Assurance Rules
1. Purpose

This document defines the non-negotiable rules of the GSDD method.

Rules are:

prescriptive

enforceable

binary (pass / fail)

Rules do not explain why.
They define what must not be violated.

2. The Wall — Architectural Rules
2.1 Domain Isolation

Rule:
Code from one domain MUST NOT import or depend on code from another domain.

Domains are isolated by responsibility

Cross-domain coupling is forbidden

Communication must occur only through explicitly defined boundaries

Violation Result:
→ Execution INVALID
→ Audit FAIL
→ ABORT

2.2 Shared Layer Restriction

Rule:
The shared layer is UI-only.

Allowed:

presentational components

styling

layout primitives

Forbidden:

business logic

domain rules

stateful decision-making

side effects

execution artifacts

Execution artifacts MUST NEVER be part of their own context snapshot.

Violation Result:
→ Execution INVALID
→ Audit FAIL
→ ABORT

2.3 Pure Domain Logic

Rule:
Domain logic MUST remain pure and isolated from UI concerns.

Domain logic MUST NOT:

import UI components

depend on rendering frameworks

access presentation state

UI layers MAY depend on domain logic.
The inverse is forbidden.

Violation Result:
→ Execution INVALID
→ Audit FAIL
→ ABORT

3. Execution Rules
3.1 Specification Authority

Rule:
No execution is permitted without a valid SPEC.

SPEC defines scope, constraints, and outcome

Execution without SPEC is forbidden

Violation Result:
→ STOP (pre-execution)
→ ABORT (if detected during execution)

3.2 Scope Immutability

Rule:
Execution scope MUST NOT change after authorization.

No new requirements

No scope expansion

No reinterpretation of intent

Violation Result:
→ ABORT

3.3 Role Separation

Rule:
Governance and Execution roles MUST remain logically separated.

Governance validates and authorizes

Execution performs actions

Execution MUST NOT:

validate its own authority

reinterpret governance decisions

Violation Result:
→ Execution INVALID
→ ABORT

4. Context Rules
4.1 Deterministic Context

Rule:
Each execution MUST operate on a deterministic context snapshot.

Context MUST be intentional

Context MUST be bounded

Context MUST be disposable

Implicit or accumulated context is forbidden.

Violation Result:
→ STOP or ABORT

4.2 No Context Inference

Rule:
Execution MUST NOT infer missing context.

If information is missing:

execution MUST NOT proceed

clarification is required

Violation Result:
→ STOP

5. Atomicity and Isolation Rules
5.1 Atomic Execution

Rule:
Each execution corresponds to exactly one outcome.

One SPEC

One scope

One execution

One outcome

One commit

Partial execution is forbidden.

Violation Result:
→ ABORT

5.2 Execution Isolation

Rule:

1 task = 1 branch = 1 execution

Executions MUST NOT:

share branches

overlap scopes

contaminate state

Violation Result:
→ Execution INVALID
→ ABORT

6. Execution Ledger Rules (NEW — MANDATORY)
6.1 Execution Ledger Requirement

Rule:
Every governed execution MUST be recorded in an Execution Ledger.

The Execution Ledger:

MUST exist as a machine-readable artifact

MUST be present at verification time

MUST correspond to the execution being verified

If the ledger does not exist, the execution is invalid regardless of outcome quality.

Violation Result:
→ Verification FAIL
→ Execution INVALID

6.2 Ledger Contract Compliance

Rule:
The Execution Ledger MUST conform to the Execution Ledger Contract.

The contract defines:

required fields

allowed values

execution state transitions

Ledgers that are malformed, incomplete, or non-conformant are invalid.

Violation Result:
→ Verification FAIL
→ Execution INVALID

6.3 Ledger–Snapshot Binding

Rule:
Each snapshot MUST be bindable to a ledger entry.

Binding MUST allow correlation between:

snapshot identifier

execution fingerprint

executor identity

execution timestamps

Unbindable snapshots are untrustworthy.

Violation Result:
→ Assurance INVALID
→ Verification FAIL

7. Verification Rules (NEW — ENFORCEMENT)
7.1 Mandatory Verification

Rule:
All finalized execution artifacts MUST be verified by a verifier.

Verification:

is read-only

performs no mutation

produces PASS / FAIL / WARN outcomes

Skipping verification is forbidden.

Violation Result:
→ Commit forbidden
→ Execution INVALID

7.2 FAIL vs WARN Semantics

Rule:

FAIL indicates a rule violation that invalidates execution

WARN indicates reduced assurance but does not invalidate execution

FAIL conditions MUST stop the pipeline.

WARN conditions MUST be visible but non-blocking.

Incorrect classification invalidates verification.

Violation Result:
→ Verification INVALID

7.3 CI Enforcement

Rule:
Verification MUST run in CI for protected branches.

Human-only verification is insufficient.

If CI verification is bypassed or disabled:

assurance is void

execution is untrusted

Violation Result:
→ Assurance INVALID

8. Audit Rules
8.1 Mandatory Audit

Rule:
Every execution MUST be audited before commit.

Audit verifies:

SPEC compliance

architectural rules

isolation guarantees

outcome integrity

Skipping audit is forbidden.

Violation Result:
→ Commit forbidden
→ ABORT

8.2 Outcome Immutability

Rule:
Outcomes MUST NOT be modified after audit and finalization.

Correction requires:

a new SPEC

a new execution

a new outcome

Violation Result:
→ Execution INVALID

9. Assurance Rules
9.1 Finalization Boundary

Rule:
Assurance applies only after explicit execution finalization.

Before finalization:

artifacts are provisional

assurance guarantees do not apply

After finalization:

execution authority terminates

artifacts become immutable evidence

Violation Result:
→ Assurance INVALID
→ Audit FAIL

9.2 Integrity Requirement

Rule:
A finalized execution artifact MUST be immutable.

Any post-finalization modification:

invalidates integrity

invalidates assurance

renders the artifact untrustworthy

Integrity is evidence-based, not preventive.

Violation Result:
→ Assurance INVALID
→ Artifact INVALID

9.3 Auditability Requirement

Rule:
Each execution artifact MUST be auditable against its governing rules.

Auditability MUST allow verification of:

execution authorization

scope conformance

outcome alignment with SPEC

Subjective acceptance is forbidden.

Violation Result:
→ Audit FAIL
→ Commit forbidden

9.4 Traceability Requirement

Rule:
Each execution artifact MUST be traceable to its execution context.

Traceability MUST allow correlation with:

executor identity

execution time

execution context

Missing traceability invalidates assurance.

Violation Result:
→ Assurance INVALID

9.5 Practical Non-Repudiation

Rule:
Execution artifacts MUST provide practical non-repudiation.

This means:

executions are attributable

denials are detectably inconsistent with evidence

Absolute cryptographic guarantees are not required.

Violation Result:
→ Assurance INVALID

10. Abuse Resistance Rule

Rule:
The method MUST NOT expose mechanisms that facilitate abuse.

Normative documentation MUST:

describe guarantees, not internals

expose properties, not attack paths

avoid procedural misuse guidance

Violation Result:
→ Governance INVALID

11. Failure Rules
11.1 STOP (Pre-execution)

Rule:
Execution MUST STOP when:

SPEC is missing or invalid

ambiguity exists

validation fails

STOP is a successful governance result.

11.2 ABORT (Post-execution)

Rule:
Execution MUST ABORT when:

rules are violated

audit fails

scope leaks occur

The Wall is crossed

Abort terminates execution immediately.

12. Auto-Healing Prohibition

Rule:
Auto-healing is forbidden within an execution.

Execution MUST NOT:

silently retry

auto-correct failures

continue after violation

Correction is only permitted via a new execution.

Violation Result:
→ Execution INVALID

13. Final Rule

No rule in this document may be bypassed, relaxed, or overridden.

Correct output does not justify rule violation.

Governance is absolute.