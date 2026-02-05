# 📜 Governança de Desenvolvimento: Plataforma Confiança Invisível

Este documento define as regras rígidas de arquitetura e conduta técnica para o **Invisible Trust Enterprise Full-Stack Guardian** (AI Buddy).

## 🏛️ 1. Arquitetura de Domínios (The Wall)

A separação entre **Site** e **Plataforma** é física e lógica. Não deve haver vazamento de dependências.

| Regra | Site (S) | Platform (P) |
| --- | --- | --- |
| **URL Root** | `/` | `/admin/*` |
| **Layout** | `SiteLayout` | `PlatformLayout` |
| **Acesso** | Público / Informativo | Autenticado / Operacional |
| **Proteção** | Nenhuma | `ProtectedRoute` + `AdminGuard` |

Schema SQL: Alterações de DDL (tabelas/colunas) devem sempre vir acompanhadas de uma nova migration numerada, preservando a retrocompatibilidade com o código de produção atual.

> **Nota:** Componentes em `/shared` devem ser puros (UI-only). Se um componente exigir lógica de plataforma, ele deve ser injetado ou movido para o domínio `Platform`.

## 🛠️ 2. Protocolo de Entrega de Código

Para garantir a estabilidade do build e evitar erros de "copy-paste", o Agente deve seguir:

* **Arquivos Integrais:** Proibido snippets. Toda entrega deve ser o arquivo completo (First line to last line).
* **Continuidade:** Arquivos que excederem o limite de caracteres serão entregues em partes via comando `continuar`.
* **Higiene:** Antes do output, o código passa por scan de:
* Imports duplicados ou não utilizados.
* Conflitos de Merge (`<<<<<<<`).
* Exports duplicados ou inconsistentes.



## 🛡️ 3. Política de Segurança e Git

* **Anti-Trauma:** Comandos destrutivos (`reset --hard`, `clean -fd`) exigem aviso de impacto, alternativa segura e plano de recuperação.
* **Conflitos:** Em caso de conflito, o Agente interrompe a sugestão e reconstrói o arquivo resolvendo a semântica e preservando todas as funcionalidades (União de Features).

## ⚙️ 4. Gestão de Features (Governance)

Qualquer alteração que não seja correção de infraestrutura é considerada **Feature**.

1. Deve ser registrada em `feature-map.md`.
2. Deve ser incluída em `stag_features`.
3. Deve ser protegida por `useFeatureFlag()`.

## 🧪 5. Checklist de Pré-Voo (Obrigatório)

Antes de cada resposta, o Agente valida:

* [ ] Build esperado: **PASS**
* [ ] Regressões: **ZERO**
* [ ] Integridade de arquivo: **COMPLETO**
* [ ] Isolamento Site/Platform: **PRESERVADO**

---

### 🚀 Próximo Passo Sugerido

Copie o conteúdo acima e salve-o como `GOVERNANCE.md` na raiz do seu projeto.

**Gostaria que eu iniciasse agora o mapeamento do seu `confiancainvisivel.zip` para validar se a estrutura de pastas atual já respeita esses contratos?**