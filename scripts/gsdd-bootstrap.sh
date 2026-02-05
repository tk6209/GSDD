#!/usr/bin/env bash
set -euo pipefail

echo "🛡️ GSDD Bootstrap — Starting"

############################################
# STEP 1 — CLEANUP (Deterministic)
############################################
echo "🧹 Cleaning local artifacts..."

# Remove macOS system files
find . -name ".DS_Store" -type f -delete || true

# Remove local GSDD state (must not be versioned)
if [ -f ".gsdd/state.json" ]; then
  rm .gsdd/state.json
  echo "Removed .gsdd/state.json"
fi

# Ensure .gitignore rules
touch .gitignore

grep -qxF ".DS_Store" .gitignore || echo ".DS_Store" >> .gitignore
grep -qxF ".gsdd/state.json" .gitignore || echo ".gsdd/state.json" >> .gitignore

# Remove from git index if already tracked
git rm --cached .DS_Store 2>/dev/null || true
git rm --cached .gsdd/state.json 2>/dev/null || true

git add .gitignore || true
git commit -m "chore: clean local system and state files" \
  || echo "No cleanup changes to commit"

############################################
# STEP 2 — TAG VERSION (Safe Automation)
############################################
echo "🏷️ Tagging version v0.1.0..."

if git rev-parse "v0.1.0" >/dev/null 2>&1; then
  echo "Tag v0.1.0 already exists — skipping"
else
  git tag -a v0.1.0 -m "GSDD v0.1.0 — Public bootstrap of the method"
fi

############################################
# STEP 3 — PUSH (Explicit)
############################################
echo "🚀 Pushing commits and tags..."

git push origin main
git push origin v0.1.0

############################################
# STEP 4 — MANUAL GOVERNED STEPS
############################################
echo ""
echo "📐 NORMALIZATION NOTICE"
echo "-----------------------------------------"
echo "Commit normalization CANNOT be automated safely."
echo "Reason: semantic separation requires human intent."
echo ""
echo "Recommended:"
echo "  git rebase -i HEAD~N"
echo ""

echo "📘 OPEN METHOD PUBLICATION"
echo "-----------------------------------------"
echo "Manual steps required:"
echo "1. Set GitHub description:"
echo "   'GSDD — Governed Specification-Driven Development (Open Method)'"
echo ""
echo "2. Add GitHub Topics:"
echo "   ai-coding, governance, specification-driven, gsdd"
echo ""
echo "3. Publish announcement (site / README / social)"
echo ""

echo "✅ GSDD Bootstrap complete."
