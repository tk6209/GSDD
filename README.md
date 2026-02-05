# GSDD — Governed Specification-Driven Development

![GSDD Version](https://img.shields.io/badge/GSDD-v0.1.0-blue)

> **Without governance, AI scales bugs.**  
> **With governance, it scales systems.**

---

## English | Português  
[English](#english) · [Português](#português)

---

<a name="english"></a>
## English

### What is GSDD?

**GSDD (Governed Specification-Driven Development)** is an open method for AI-assisted software development that enforces **explicit governance over execution**.

It transforms AI from an improvisational code generator into a **bounded executor**, operating strictly within:

- explicit specifications  
- declared architectural boundaries  
- verifiable execution rules  

GSDD does not optimize for speed.  
It optimizes for **trust, auditability, and predictability**.

---

### The Core Problem

AI coding failures are **not model failures**.  
They are **governance failures**.

Common systemic anti-patterns:

- **Context Drift**  
  Long sessions silently degrade intent and correctness.

- **Implicit Specification Fallacy**  
  Assuming “the AI understood” without an explicit contract.

- **Execution Bleed**  
  One task leaking into another, contaminating scope.

- **Conversational Authority**  
  Accepting output because it *sounds right*, not because it is verifiable.

> The problem is not AI capability.  
> The problem is **ungoverned execution**.

---

### The GSDD Principle

> **No contract, no execution.**

In GSDD:

- humans define intent, scope, and limits  
- AI executes only after governance is validated  
- verification is mandatory  
- aborting invalid execution is considered success  

---

### The GSDD Execution Flow

Execution is only valid when **all steps are followed**:

1. **Declare Scope** — a single, bounded, explicit scope  
2. **Declare SPEC** — written, testable specification  
3. **Validate SPEC** — structural validation against the contract  
4. **Authorize Execution** — explicit governance approval  
5. **Execute** — atomic execution within declared boundaries  
6. **Verify Outcome & Commit** — invalid outcomes **must not be committed**  
7. **Terminate Execution** — no continuation without restart  

This flow is **mandatory**.  
Any deviation invalidates the execution.

---

### Core Guarantees

GSDD guarantees:

- explicit governance before execution  
- architecture treated as law, not convention  
- deterministic execution boundaries  
- auditability and traceability  
- safe aborts instead of silent failure  

GSDD explicitly does **not** provide:

- auto-fix  
- auto-healing  
- speculative execution  
- implicit scope expansion  

---

## CLI (Bootstrap)

GSDD includes a **governed command-line interface**.

```bash
./scripts/gsdd help
./scripts/gsdd verify <spec.md>
./scripts/gsdd snapshot
./scripts/gsdd audit
CLI Guarantees
structure-only validation

no auto-fix

no auto-healing

no SPEC mutation

deterministic pass / fail

Only verify is normative in v0.1.0.
Other commands are placeholders by design.

The CLI enforces.
It does not negotiate.

Who is GSDD for?
GSDD does not require changing your tech stack.
It requires changing your execution contract.

Solo developers — personal governance and confidence

Small teams — alignment without process bloat

Distributed teams — explicit contracts across contexts

Enterprises — auditability, compliance, and scale

Status
Version: v0.1.0

Method: Stable (bootstrap)

CLI: Published

verify: Normative

Other commands: Non-operative by design

<a name="português"></a>

Português
O que é o GSDD?
GSDD (Governed Specification-Driven Development) é um método aberto para desenvolvimento de software assistido por IA que impõe governança explícita sobre a execução.

Ele transforma a IA de um gerador improvisado de código em um executor limitado, operando estritamente dentro de:

especificações explícitas

limites arquiteturais declarados

regras verificáveis de execução

O GSDD não otimiza velocidade.
Ele otimiza confiança, auditabilidade e previsibilidade.

O Problema Central
Falhas no uso de IA não são falhas do modelo.
São falhas de governança.

Anti-padrões sistêmicos comuns:

Context Drift (Deriva de Contexto)
Sessões longas degradam intenção e correção.

Falácia da Especificação Implícita
Assumir que “a IA entendeu” sem contrato explícito.

Execution Bleed (Vazamento de Execução)
Uma tarefa invade outra e contamina o escopo.

Autoridade Conversacional
Aceitar código porque “parece certo”.

O problema não é a IA.
É a execução não governada.

Princípio do GSDD
Sem contrato, sem execução.

No GSDD:

humanos definem intenção, escopo e limites

a IA executa apenas após validação da governança

verificação é obrigatória

abortar execução inválida é sucesso operacional

Garantias Fundamentais
O GSDD garante:

governança explícita antes da execução

arquitetura tratada como lei

limites determinísticos

auditabilidade e rastreabilidade

abortos seguros

O GSDD não oferece:

auto-fix

auto-healing

execução especulativa

expansão implícita de escopo

FAQ — Frequently Asked Questions
❓ Is GSDD available via pip, pip3, or Homebrew?
No. Not yet.

GSDD is intentionally not distributed via package managers in v0.1.x.

GSDD is a method first, not a tool-first product.
Packaging it too early would create incorrect expectations.

The repository distribution ensures users:

read the method

understand the contracts

adopt governance consciously

❓ When will it be packaged?
Only after semantic closure, no earlier than v1.0.0.
See ROADMAP.md.

FAQ — Perguntas Frequentes (Português)
❓ O GSDD está disponível via pip ou Homebrew?
Não. Ainda não.

Isso é intencional.

O GSDD é um método primeiro, não uma ferramenta pronta.
Empacotamento virá apenas após fechamento semântico (v1.0.0).

Final Note
GSDD is not defined by tools.

It is defined by governed limits,
explicit contracts,
and evidence-based accountability.

Created by Vinicius Teixeira
Governed Specification-Driven Development — Open Method