# Contributing to GSDD / Contribuindo com o GSDD

[English](#english) | [Português](#português)

---

## English

### Governance First
GSDD is an **Open Method**, but it is not an “anything goes” repository.
Contributions are accepted only if they preserve the method’s core guarantees:

- **No contract, no execution**
- **Stop on ambiguity**
- **No implicit scope expansion**
- **No auto-healing during execution**
- **Auditability over convenience**

### What You Can Contribute
- Clarity improvements to normative documents (`gsdd_core.md`, `execution_flow.md`, `spec_contract.md`)
- Additional conceptual references under `method/` (property-based, non-operational)
- Templates that improve SPEC quality (without becoming “tool-specific”)
- CI checks that verify invariants (block, don’t “fix”)

### What We Do Not Accept
- Any change that weakens governance language (MUST → SHOULD)
- “Auto-fix”, “auto-heal”, or mutation of SPEC after authorization
- Tool-specific behavior embedded into normative documents
- Large refactors without explicit scope and justification

### Contribution Process (Governed)
1. Create a branch with a semantic name (`feat/...`, `docs/...`, `chore/...`).
2. Open a PR with a single scope.
3. Explain the change using:
   - **Problem**
   - **Proposed change**
   - **Impact on guarantees**
   - **How to verify**
4. If the change affects guarantees, maintainers may request a governance review.

### Licensing
By contributing, you agree your contribution is released under the repository license.

---

## Português

### Governança Primeiro
O GSDD é um **Open Method**, mas não é um repositório “vale tudo”.
Contribuições só são aceitas se preservarem as garantias centrais do método:

- **Sem contrato, sem execução**
- **Pare diante de ambiguidade**
- **Sem expansão implícita de escopo**
- **Sem auto-healing durante a execução**
- **Auditabilidade acima de conveniência**

### O que você pode contribuir
- Melhorias de clareza nos documentos normativos (`gsdd_core.md`, `execution_flow.md`, `spec_contract.md`)
- Conteúdo conceitual em `method/` (baseado em propriedades, não operacional)
- Templates para melhorar qualidade de SPEC (sem amarrar em ferramenta)
- Checks de CI que validem invariantes (bloquear, não “consertar”)

### O que não aceitamos
- Qualquer mudança que enfraqueça a linguagem de governança (MUST → SHOULD)
- “Auto-fix”, “auto-heal” ou mutação de SPEC após autorização
- Comportamento tool-specific dentro dos normativos
- Refactors grandes sem escopo explícito e justificativa

### Processo de contribuição (governado)
1. Crie uma branch com nome semântico
2. Abra um PR com escopo único.
3. Explique a mudança usando:
   - **Problema**
   - **Mudança proposta**
   - **Impacto nas garantias**
   - **Como verificar**
4. Se a mudança afetar garantias, os maintainers podem solicitar revisão de governança.

### Licenciamento
Ao contribuir, você concorda que sua contribuição será distribuída sob a licença do repositório.
