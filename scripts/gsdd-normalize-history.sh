#!/usr/bin/env bash
set -e

echo "GSDD — HISTORY NORMALIZATION (GUIDED)"

cat << 'DOC'
This process CANNOT be automated safely.

Goal:
Split the bootstrap commit into semantic commits:

1. core            → gsdd_core.md, integrity.md
2. execution       → execution_flow.md, method/*
3. spec            → spec_contract.md, docs/terminology.md
4. audit/trace     → auditability.md, traceability.md, assurance.md

Recommended procedure:

1) Identify how many commits to rewrite:
   git log --oneline

2) Start interactive rebase:
   git rebase -i HEAD~N

3) Mark the bootstrap commit as:
   edit

4) During rebase, split commits manually:
   git reset HEAD^
   git add <files>
   git commit -m "core: establish GSDD core law"
   git add <files>
   git commit -m "execution: define governed execution flow"
   git add <files>
   git commit -m "spec: define specification contract"
   git add <files>
   git commit -m "audit: add auditability and traceability"

5) Continue rebase:
   git rebase --continue

STOP CONDITIONS:
- If unsure about semantic grouping → ABORT
- If conflicts arise → RESOLVE manually, never force

This is a GOVERNANCE operation.
Human intent is mandatory.
DOC
