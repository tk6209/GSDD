# GSDD — Governed Specification-Driven Development

> **“Without governance, AI scales bugs.  
> With governance, it scales systems.”**

GSDD is a **governed execution method** for AI-assisted development.
It transforms AI output into **auditable, deterministic, and contract-bound execution**, eliminating improvisation, silent failures, and uncontrolled scope expansion.

GSDD is **tool-agnostic**, **agent-agnostic**, and has been **validated in real production pipelines** through multiple epics and pull requests with zero merge conflicts.

---

## Why GSDD Exists

AI-assisted development fails not because models are weak, but because **execution is unguided**.

Common systemic failures include:

- **Context Drift**  
  Accumulated noise across long sessions contaminates decisions.

- **Implicit Specification Fallacy**  
  Assuming the model “understands” intent without a contract.

- **Execution Bleed**  
  Side changes silently escape the intended scope.

- **Conversational Authority**  
  Code is accepted because it sounds plausible, not because it is correct.

GSDD addresses these failures **by design**, not by discipline.

---

## What GSDD Is (and Is Not)

### GSDD **is**
- A **method**, not a prompt
- A **governed execution model**, not auto-completion
- **Specification-first**, not conversation-first
- **Audit-driven**, not trial-and-error
- Designed for **serious systems**, teams, and long-lived codebases

### GSDD **is not**
- A framework
- A coding assistant
- A self-healing loop
- A Git workflow trick
- Dependent on any specific AI tool

---

## Core Execution Model (High Level)

At its core, GSDD enforces a **strict execution ritual**:

1. **Declare Scope**  
   A single, bounded execution scope is explicitly defined.

2. **Declare and Validate a SPEC**  
   Execution is authorized only by a complete, unambiguous specification.

3. **Authorize Execution**  
   Governance explicitly transitions into execution.

4. **Execute Once, Atomically**  
   1 task · 1 context · 1 branch · 1 execution · 1 commit.

5. **Audit the Outcome**  
   Results are verified against the SPEC.  
   Audit failure forbids commit.

6. **Commit or Terminate**  
   If rules are violated, aborting is a success — not a failure.

This ritual is fully defined in the method’s normative documents.

---

## Foundational Principles

- **Specifications are contracts**  
  No contract, no execution.

- **Context is disposable**  
  Every execution starts from an explicit, minimal context.

- **Execution is finite**  
  No silent retries. No hidden loops.

- **Audit precedes acceptance**  
  Outcomes are verified before they are committed.

- **Correction means re-execution**  
  Fixing requires a new SPEC and a new execution.

---

## Repository Structure

This repository separates **method**, **documentation**, and **enforcement**:

- `GSDD_CORE.md` — The law (what is allowed and forbidden)
- `EXECUTION_FLOW.md` — The ritual (mandatory sequence)
- `SPEC_CONTRACT.md` — What constitutes a valid SPEC
- `/docs` — Informational and explanatory material
- `/skills` — Optional enforcement layers (Codex, CLI, etc.)

The method exists independently of any tooling.

---

## Status

GSDD is **actively used and validated**.
The repository reflects a **crystallized method**, not an experiment.

---

## Author

Created and maintained by  
**Vinicius Teixeira**  

---

## CLI (Bootstrap)

GSDD includes a governed command-line interface.

### Available Commands

```bash
./scripts/gsdd verify <spec.md>
```

### Guarantees

- Structure-only validation
- No auto-fix
- No auto-healing
- No SPEC mutation
- Deterministic pass / fail

Only `verify` is normative in v0.1.0.
Other commands are placeholders by design.
