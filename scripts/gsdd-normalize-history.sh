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
