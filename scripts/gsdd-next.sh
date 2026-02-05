#!/usr/bin/env bash
set -euo pipefail

say() { printf "\n%s\n" "$1"; }

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

say "🛡️ GSDD Next — Starting"
say "Repo: $ROOT"

# --- Guards
if [[ ! -d .git ]]; then
  echo "ERROR: Not a git repo."
  exit 1
fi

if [[ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]]; then
  echo "ERROR: You are not on main. Checkout main first."
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: Working tree not clean. Commit/stash first."
  git status --porcelain
  exit 1
fi

# ---------------------------
# 1) Implement gsdd verify
# ---------------------------
say "✅ 1/4 Implementing: scripts/gsdd verify (real validator)"

mkdir -p scripts

cat > scripts/gsdd <<'CLI'
#!/usr/bin/env bash
set -euo pipefail

cmd="${1:-help}"

print_help() {
  cat <<'H'
🛡️  GSDD CLI

Commands:
  gsdd verify <spec.md>     Validate a SPEC file (structure-only) against the GSDD SPEC contract
  gsdd snapshot             Create a snapshot artifact (placeholder)
  gsdd audit                Verify outcome against SPEC (placeholder)
  gsdd help                 Show this help

Rules:
- The CLI never auto-fixes.
- The CLI never auto-heals.
- The CLI never mutates a SPEC.
- The CLI only verifies, blocks, and records.
H
}

# Normalize headings (case-insensitive) and accept common aliases.
# SPEC is expected to be a Markdown document with headings.
verify_spec() {
  local file="${1:-}"
  if [[ -z "$file" ]]; then
    echo "ERROR: Missing SPEC path."
    echo "Usage: gsdd verify <spec.md>"
    exit 2
  fi
  if [[ ! -f "$file" ]]; then
    echo "ERROR: SPEC file not found: $file"
    exit 2
  fi

  # Required fields (as headings). We accept both "## X" and "# X" and any level.
  # Aliases cover EN/PT and common variations.
  local -a required_keys=(
    "scope"
    "objective"
    "inputs"
    "constraints"
    "expected outcome"
  )

  # Aliases map: canonical -> regex alternatives
  # Note: keep this strict; do not infer missing content.
  declare -A alias
  alias["scope"]="scope|escopo"
  alias["objective"]="objective|objetivo"
  alias["inputs"]="inputs|input|entradas"
  alias["constraints"]="constraints|constraint|restri(c|ç)ões|restricoes"
  alias["expected outcome"]="expected outcome|expected results?|outcome|resultado esperado|resultados esperados"

  # Read file once
  local content
  content="$(cat "$file")"

  # Track missing
  local -a missing=()

  for key in "${required_keys[@]}"; do
    local re="${alias[$key]}"
    # Match markdown heading with that key
    # Examples:
    #   ## Scope
    #   ### Objective
    #   # Expected Outcome
    if ! printf "%s\n" "$content" | LC_ALL=C grep -Eiq '^[[:space:]]{0,3}#{1,6}[[:space:]]+('"$re"')[[:space:]]*$'; then
      missing+=("$key")
    fi
  done

  if (( ${#missing[@]} > 0 )); then
    echo "❌ SPEC INVALID (missing mandatory sections):"
    for m in "${missing[@]}"; do
      echo "  - $m"
    done
    echo
    echo "STOP: Execution is forbidden without a valid SPEC."
    exit 1
  fi

  # Optional: verify headings contain some body text after them (basic, still structure-only).
  # We do not parse semantics, only ensure each required section has at least 1 non-empty line beneath it.
  local fail_body=0
  for key in "${required_keys[@]}"; do
    local re="${alias[$key]}"
    # Extract block after heading until next heading.
    # This is conservative and avoids complex parsing.
    block="$(python3 - <<PY
import re,sys
text=open("$file","r",encoding="utf-8",errors="ignore").read().splitlines()
pattern=re.compile(r'^[ \\t]{0,3}#{1,6}[ \\t]+(' + r"$re" + r')[ \\t]*$', re.I)
start=None
for i,line in enumerate(text):
    if pattern.match(line):
        start=i+1
        break
if start is None:
    print("")
    sys.exit(0)
out=[]
for j in range(start,len(text)):
    if re.match(r'^[ \\t]{0,3}#{1,6}[ \\t]+', text[j]):
        break
    out.append(text[j])
print("\\n".join(out).strip())
PY
)"
    if [[ -z "${block//[[:space:]]/}" ]]; then
      echo "❌ SPEC INVALID (empty section): $key"
      fail_body=1
    fi
  done

  if [[ "$fail_body" -eq 1 ]]; then
    echo
    echo "STOP: SPEC sections must not be empty."
    exit 1
  fi

  echo "✅ SPEC VALID (structure-only): $file"
}

case "$cmd" in
  verify)
    shift
    verify_spec "${1:-}"
    ;;
  snapshot)
    echo "🧊 snapshot: placeholder (bootstrap)."
    ;;
  audit)
    echo "🧪 audit: placeholder (bootstrap)."
    ;;
  help|--help|-h|"")
    print_help
    ;;
  *)
    echo "ERROR: Unknown command: $cmd"
    echo
    print_help
    exit 2
    ;;
esac
CLI

chmod +x scripts/gsdd

# Quick self-check
./scripts/gsdd help >/dev/null

say "🔎 Creating a minimal SPEC template for users (docs/spec-template.md)"
mkdir -p docs
cat > docs/spec-template.md <<'SPEC'
# GSDD SPEC — Template / Modelo

## Scope / Escopo
- Single, bounded scope statement.

## Objective / Objetivo
- Intended outcome (testable).

## Inputs / Entradas
- List all required inputs explicitly (no assumptions).

## Constraints / Restrições
- List constraints and explicit non-goals.

## Expected Outcome / Resultado Esperado
- Completion criteria (verifiable).
SPEC

say "📦 Commit 1: verify implementation + template"
git add scripts/gsdd docs/spec-template.md
git commit -m "feat(verify): implement structure-only SPEC validator"

# ---------------------------
# 2) CONTRIBUTING.md governed
# ---------------------------
say "✅ 2/4 Creating: CONTRIBUTING.md (governed, EN/PT)"

cat > CONTRIBUTING.md <<'CONTRIB'
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
CONTRIB

say "📦 Commit 2: CONTRIBUTING.md"
git add CONTRIBUTING.md
git commit -m "docs: add governed contributing guidelines"

# ---------------------------
# 3) Launch post (EN/PT)
# ---------------------------
say "✅ 3/4 Creating: POST_LAUNCH.md (official launch copy, EN/PT)"

cat > POST_LAUNCH.md <<'POST'
# GSDD v0.1.0 — Official Launch Post / Post Oficial de Lançamento

[English](#english) | [Português](#português)

---

## English

**GSDD (Governed Specification-Driven Development)** is an Open Method for AI-assisted development.

Without governance, AI scales bugs.  
With governance, it scales systems.

GSDD does not compete with AI tools. It defines **when execution is allowed**.

### The Problem
AI coding fails at scale due to systemic anti-patterns:
- **Context Drift**: long sessions degrade focus and correctness
- **Implicit Spec Fallacy**: “the AI understood” without a contract
- **Execution Bleed**: unintended side-changes contaminate the codebase
- **Conversational Authority**: accepting code because it “sounds right”

### The Method
GSDD turns execution into a governed contract:
- **Specifications are contracts**: no contract, no execution
- **Architecture is law**: boundaries are enforced, not negotiated
- **Execution is atomic**: one scope, one execution, one outcome
- **Auditability is mandatory**: verify outcome before commit
- **Failure must be explicit**: aborting is operational success

### What’s in v0.1.0
- Normative method documents (Core Law, Execution Flow, SPEC Contract)
- A minimal Skill for governed operation with LLMs
- A bootstrap CLI skeleton (verify/snapshot/audit)
- Templates and publication artifacts

### Start Here
- Read the normative documents
- Use the SPEC template
- Run `gsdd verify` to validate structure before any execution

If you work with AI as part of your job, GSDD can help you move from improvisation to governed delivery.

---

## Português

**GSDD (Governed Specification-Driven Development)** é um Open Method para desenvolvimento assistido por IA.

Sem governança, a IA escala bugs.  
Com governança, ela escala sistemas.

O GSDD não compete com ferramentas de IA. Ele define **quando a execução é permitida**.

### O Problema
Codar com IA falha em escala por anti-padrões sistêmicos:
- **Context Drift**: sessões longas degradam foco e correção
- **Falácia da SPEC implícita**: “a IA entendeu” sem contrato
- **Execution Bleed**: mudanças laterais contaminam o código
- **Autoridade Conversacional**: aceitar código porque “parece certo”

### O Método
O GSDD transforma execução em contrato governado:
- **SPEC é contrato**: sem contrato, sem execução
- **Arquitetura é lei**: limites são aplicados, não negociados
- **Execução é atômica**: um escopo, uma execução, um outcome
- **Auditabilidade é obrigatória**: verificar outcome antes do commit
- **Falha deve ser explícita**: abortar é sucesso operacional

### O que tem no v0.1.0
- Documentos normativos (Lei, Fluxo, Contrato de SPEC)
- Skill mínima para operar com LLMs sob governança
- CLI bootstrap (verify/snapshot/audit)
- Templates e artefatos de publicação

### Comece por aqui
- Leia os documentos normativos
- Use o template de SPEC
- Rode `gsdd verify` para validar a estrutura antes de qualquer execução

Se você usa IA como parte do seu trabalho, o GSDD ajuda a sair da improvisação para entrega governada.
POST

say "📦 Commit 3: launch post"
git add POST_LAUNCH.md
git commit -m "docs: add official v0.1.0 launch post"

# ---------------------------
# 4) History normalization (guided, optional)
# ---------------------------
say "🟡 4/4 History normalization (GUIDED, not automated)"

cat > scripts/gsdd-normalize-history.sh <<'NORM'
#!/usr/bin/env bash
set -euo pipefail

cat <<'DOC'
📐 GSDD — HISTORY NORMALIZATION (GUIDED)

This process MUST NOT be automated.
Semantic separation requires human intent.

Goal:
Split a large bootstrap commit into semantic commits, for example:
1) core            → gsdd_core.md, integrity.md
2) execution       → execution_flow.md, method/*
3) spec            → spec_contract.md, docs/terminology.md
4) audit/trace     → auditability.md, traceability.md, assurance.md

Procedure:
1) Inspect history:
   git log --oneline --decorate -n 20

2) Start interactive rebase (choose N):
   git rebase -i HEAD~N

3) Mark the target commit as:
   edit

4) Split during rebase:
   git reset HEAD^
   git add <files>
   git commit -m "core: establish GSDD core law"
   git add <files>
   git commit -m "execution: define governed execution flow"
   git add <files>
   git commit -m "spec: define specification contract"
   git add <files>
   git commit -m "audit: add auditability and traceability"

5) Continue:
   git rebase --continue

STOP CONDITIONS:
- If unsure about semantic grouping → ABORT (git rebase --abort)
- If conflicts arise → RESOLVE manually, never force
DOC
NORM

chmod +x scripts/gsdd-normalize-history.sh

say "📦 Commit 4: guided normalization script"
git add scripts/gsdd-normalize-history.sh
git commit -m "chore: add guided history normalization script"

# ---------------------------
# Final push
# ---------------------------
say "🚀 Pushing commits..."
git push origin main

say "✅ Done."
say "Next:"
say " - Run: ./scripts/gsdd help"
say " - Try: ./scripts/gsdd verify docs/spec-template.md"
say " - Optional: ./scripts/gsdd-normalize-history.sh"
