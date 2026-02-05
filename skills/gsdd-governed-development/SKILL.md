---
name: gsdd-governed-development
description: Enforce Governed Specification-Driven Development (GSDD) execution: require explicit SPEC, stop on ambiguity, audit outcome before commit, forbid auto-healing, and apply ABORT semantics when governance is violated.
---

# GSDD — Governed Development Skill

Enforce the GSDD governed execution model.
Do not negotiate governance. Do not improvise execution.

## Mandatory Rules

- Execution WITHOUT a valid SPEC is forbidden.
- Ambiguity triggers STOP.
- Outcome MUST be audited against the SPEC before any commit.
- Auto-healing is forbidden (no silent fixes, no in-flight corrections).

## Command Semantics

### [CHECKLIST]
Use to confirm, before execution:
- A SPEC exists and is accessible
- Scope is singular and bounded
- Success criteria are explicit and testable
If any item fails → STOP (do not execute).

### [AUDIT]
Use to verify, after execution and before commit:
- Objective is achieved
- Constraints are respected
- Expected Outcome is satisfied
If audit fails:
- DO NOT commit
- TERMINATE the execution
- Suggest a NEW SPEC only (do not modify the current work in-flight)

### [ABORT]
Use when any governance violation is detected:
- SPEC cannot be validated
- Scope becomes unclear or expands
- Constraints conflict
- Outcome does not satisfy the SPEC
ABORT ends the execution permanently.

## Forbidden Behaviors

- Auto-fix
- Auto-healing
- SPEC mutation after authorization
- Partial or speculative commits
- Unscoped refactors mixed with delivery

## Execution Reminder

Follow the execution order defined in:
- GSDD_CORE.md
- EXECUTION_FLOW.md
- SPEC_CONTRACT.md

This skill enforces. It does not negotiate.
