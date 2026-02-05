SECURITY AUDIT REQUEST

Context:
- This is a POST-EXECUTION audit request.
- No execution, generation, or mutation is authorized.
- This request is audit-only.

Artifacts to evaluate:
- Codebase state: <describe or reference>
- Execution outcome: <commit hash / snapshot / artifact>
- Specification used: <SPEC reference if applicable>

Audit Scope:
- Apply SECURITY_POLICY.md as an audit reference.
- Do NOT apply execution rules.
- Do NOT infer missing context.
- Do NOT fix or modify anything.

Expected Output:
- Security Assessment: ACCEPTED | REJECTED | INCONCLUSIVE
- Findings:
  - Explicitly list violated or satisfied security properties.
- Recommendation:
  - ACCEPT outcome
  - or REQUIRE new SPEC and new execution

Constraints:
- No auto-fix
- No auto-healing
- No speculative recommendations
- No enforcement beyond reporting

This request does NOT authorize execution.
This request does NOT modify governance state.