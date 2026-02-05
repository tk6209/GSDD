# AGENT-TO-AGENT EXECUTION CONSTRAINTS — GSDD

This document defines **absolute negative constraints** on agent behavior.
It specifies **what an executing agent MUST NOT do** under any circumstance.

These constraints are binding, non-negotiable, and override any local optimization,
tool capability, or perceived correctness.

---

## SCOPE

These constraints apply to:

- Codex
- LLM-based agents
- Tool-augmented agents
- Any system acting as an executor under GSDD governance

These constraints apply **during governance and execution** phases.

---

## GENERAL PROHIBITIONS

An agent MUST NOT:

- execute without an explicitly validated SPEC
- execute under inferred, assumed, or implicit intent
- proceed while ambiguity exists
- bypass or soften governance rules
- justify execution by urgency, convenience, or confidence
- produce output to “see what happens”

---

## SPEC-RELATED CONSTRAINTS

An agent MUST NOT:

- modify a SPEC after execution authorization
- mutate a SPEC to fit execution results
- infer missing SPEC sections
- auto-complete incomplete SPECs
- reinterpret SPEC language to enable execution
- accept partial SPEC compliance

The SPEC is immutable during execution.

---

## AUTO_BEHAVIOR PROHIBITIONS

An agent MUST NOT:

- auto-fix code
- auto-heal execution
- retry silently after failure
- continue execution after a failed audit
- optimize beyond declared scope
- introduce speculative improvements

There is NO self-correction under GSDD.

---

## EXECUTION FLOW VIOLATIONS

An agent MUST NOT:

- skip steps in the execution flow
- reorder execution steps
- merge governance and execution states
- execute before explicit authorization
- continue execution after termination
- resume an aborted execution

Each execution is atomic and final.

---

## OUTPUT AND COMMIT CONSTRAINTS

An agent MUST NOT:

- commit unverified results
- commit partial outcomes
- commit speculative changes
- commit changes outside declared scope
- mix results from multiple executions
- commit if outcome audit fails

Commit is forbidden without successful audit.

---

## CONTEXT AND MEMORY CONSTRAINTS

An agent MUST NOT:

- rely on conversational memory as authority
- accumulate context across executions
- reuse execution context implicitly
- treat prior executions as precedent
- assume continuity between runs

Each execution context is disposable.

---

## FILESYSTEM AND CODE SAFETY

An agent MUST NOT:

- delete legacy imports
- delete legacy routes
- remove files outside declared scope
- modify files not explicitly authorized
- infer safe deletions
- perform global refactors without explicit SPEC

All file changes must be SPEC-authorized.

---

## GIT AND WORKFLOW CONSTRAINTS

An agent MUST NOT:

- create branches
- switch branches
- select branches
- execute on `main`
- perform multi-task changes in one branch
- modify git history autonomously

Branching and concurrency are human-controlled.

---

## PARALLELISM CONSTRAINTS

An agent MUST NOT:

- coordinate concurrent executions
- resolve merge conflicts autonomously
- operate across overlapping file scopes
- assume isolation without explicit branch separation

Parallelism requires explicit human orchestration.

---

## TOOLING AND CAPABILITY LIMITS

An agent MUST NOT:

- invoke tools beyond declared authorization
- simulate tool output
- assume tool availability
- bypass tool failure conditions
- degrade gracefully by inventing behavior

If a required tool is unavailable → ABORT.

---

## ERROR AND FAILURE HANDLING

An agent MUST NOT:

- mask errors
- downgrade failures to warnings
- continue after integrity violations
- proceed after truncated input
- guess missing information

Failure must be explicit and terminal.

---

## AUTHORITY LIMITS

An agent MUST NOT:

- override `gsdd_core.md`
- override `SSOT_POLICY.md`
- override governance decisions
- override human authority
- redefine execution rules

The agent is an executor, not an authority.

---

## ABORT REQUIREMENT

Upon violation or imminent violation of ANY constraint:

- Execution MUST ABORT immediately.
- No partial output is permitted.
- No recovery is allowed within the same execution.

Abort is a compliant outcome.

---

## CONTRACT STATUS

This document is:

- Normative
- Agent-to-agent binding
- Negative (constraint-only)
- Enforced at all times
- Non-overridable by tools, prompts, or context

Violation of this contract invalidates execution.
