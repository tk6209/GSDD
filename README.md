# GSDD — Governed Specification-Driven Development

![GSDD Version](https://img.shields.io/badge/GSDD-v0.1.0-blue)

> **Without governance, AI scales bugs.  
> With governance, it scales systems.**

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

1. **Declare Scope**  
   A single, bounded, explicit scope.

2. **Declare SPEC**  
   A written, testable specification aligned to the scope.

3. **Validate SPEC**  
   Structural validation against the SPEC contract.

4. **Authorize Execution**  
   Explicit transition from governance to action.

5. **Execute**  
   Atomic execution within declared boundaries only.

6. **Verify Outcome & Commit**  
   Results must satisfy the SPEC.  
   Invalid outcomes **must not be committed**.

7. **Terminate Execution**  
   No continuation without restarting the flow.

This flow is **mandatory**.  
Deviation invalidates the execution.

---

### Core Guarantees

GSDD guarantees:

- Explicit governance before execution
- Architecture treated as law, not convention
- Deterministic execution boundaries
- Auditability and traceability
- Safe aborts instead of silent failure

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
Guarantees
Structure-only validation

No auto-fix

No auto-healing

No SPEC mutation

Deterministic pass / fail

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

O Princípio do GSDD
Sem contrato, sem execução.

No GSDD:

humanos definem intenção, escopo e limites

a IA executa apenas após validação da governança

verificação é obrigatória

abortar execução inválida é sucesso operacional

Fluxo de Execução do GSDD
A execução só é válida quando todas as etapas são seguidas:

Declarar Escopo

Declarar SPEC

Validar SPEC

Autorizar Execução

Executar

Verificar Resultado e Commitar

Encerrar Execução

Qualquer desvio invalida a execução.

Garantias Fundamentais
O GSDD garante:

Governança explícita antes da execução

Arquitetura tratada como lei

Limites determinísticos

Auditabilidade e rastreabilidade

Abortos seguros

O GSDD não oferece:

auto-fix

auto-healing

execução especulativa

expansão implícita de escopo

CLI (Bootstrap)
O GSDD inclui uma interface de linha de comando governada.

./scripts/gsdd verify <spec.md>
Garantias
Validação apenas estrutural

Sem auto-fix

Sem auto-healing

Sem mutação de SPEC

Aprovação/reprovação determinística

Apenas verify é normativo no v0.1.0.
Os demais comandos são placeholders por design.

Status
Versão: v0.1.0

Método: Estável (bootstrap)

CLI: Publicado

verify: Normativo

Final Note
GSDD is not defined by tools.

It is defined by governed limits,
explicit contracts,
and evidence-based accountability.

Created by Vinicius Teixeira
Governed Specification-Driven Development — Open Method

