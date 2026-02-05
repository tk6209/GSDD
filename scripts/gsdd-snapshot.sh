#!/bin/bash
set -euo pipefail

GIT_TAG="$(git describe --tags --exact-match 2>/dev/null || true)"

############################################
# Spinner (Ritual Visual — Non-Intrusive)
############################################
spinner() {
  local pid=$1
  local delay=0.12
  local spin='⏳⌛'

  while kill -0 "$pid" 2>/dev/null; do
    for ((i=0; i<${#spin}; i++)); do
      printf "\r%s Executing governed snapshot..." "${spin:$i:1}"
      sleep $delay
    done
  done
  printf "\r✅ Execution phase completed.           \n"
}

############################################
# 0. Executor Identity Resolution (Governed)
############################################
resolve_executor_id() {
  if [ -n "${GSDD_EXECUTOR_ID:-}" ]; then
    echo "$GSDD_EXECUTOR_ID"
    return
  fi

  if [ -n "${CI:-}" ]; then
    if [ -n "${GITHUB_ACTOR:-}" ]; then
      echo "ci:github:${GITHUB_ACTOR}"
      return
    fi
    if [ -n "${GITLAB_USER_LOGIN:-}" ]; then
      echo "ci:gitlab:${GITLAB_USER_LOGIN}"
      return
    fi
    echo "ci:unknown"
    return
  fi

  if command -v whoami >/dev/null 2>&1; then
    echo "local:$(whoami)"
    return
  fi

  echo "unknown_executor"
}

EXECUTOR_ID="$(resolve_executor_id)"

############################################
# 1. Project Identity
############################################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_NAME="$(basename "$PROJECT_ROOT" | tr '[:upper:]' '[:lower:]')"

############################################
# 2. Snapshot Naming
############################################
DATE_UTC="$(date -u +"%Y%m%d")"
BASE_NAME="${PROJECT_NAME}${DATE_UTC}"
EXT=".md"

VERSION=1
while [ -f "${BASE_NAME}_v$(printf "%03d" "$VERSION")$EXT" ]; do
  VERSION=$((VERSION + 1))
done

OUTPUT="${BASE_NAME}_v$(printf "%03d" "$VERSION")$EXT"

############################################
# 3. Execution Fingerprint (Deterministic)
############################################
GIT_REF="$(git rev-parse HEAD 2>/dev/null || echo 'nogit')"

EXECUTION_FINGERPRINT="$(printf "%s|%s|%s|%s" \
  "$PROJECT_NAME" \
  "$DATE_UTC" \
  "$EXECUTOR_ID" \
  "$GIT_REF" \
  | shasum | awk '{print $1}')"

############################################
# 4. Governed Header (SSOT)
############################################
{
  echo "# [SYSTEM_PROMPT: GSDD_CORE_V5]"
  echo "# PROJECT: ${PROJECT_NAME}"
  echo "# SNAPSHOT_ID: ${OUTPUT}"
  echo "# EXECUTED_BY: ${EXECUTOR_ID}"
  echo "# EXECUTION_FINGERPRINT: ${EXECUTION_FINGERPRINT}"
  echo "# RELEASE_TAG: ${GIT_TAG:-none}"
  echo "# GENERATED_AT: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "# GENERATED_BY: GSDD_METHOD"
  echo "# PROVENANCE: governed-specification-driven-development"
  echo "# OFFICIAL_REPOSITORY: https://github.com/tk6209/gsdd"
  echo "# OFFICIAL_SITE: https://confiancainvisivel.com.br/gsdd"
  echo ""
  echo "# DISCLAIMER:"
  echo "# This open method is provided \"AS IS\" and \"AS AVAILABLE\"."
  echo ""
  echo "# WATERMARK: GSDD::OFFICIAL_SNAPSHOT"
  echo ""
  echo "## [GOVERNANCE_CONSTRAINTS]"
  echo "- SSOT: This file is the Single Source of Truth."
  echo "- THE_WALL: Architectural boundaries are non-negotiable."
  echo "- NO_SNIPPETS: Only full-file outputs are allowed."
  echo ""
  echo "---"
  echo ""
  echo "## [EXECUTION_ATTENTION_MAP]"
  echo ""
  echo "READ_MANDATORY:"
  echo "- spec_contract.md"
  echo "- execution_flow.md"
  echo ""
  echo "READ_OPTIONAL:"
  echo "- assurance.md"
  echo "- auditability.md"
  echo "- integrity.md"
  echo "- traceability.md"
  echo ""
  echo "READ_FORBIDDEN:"
  echo "- readme.md"
  echo "- docs/whitepaper.pdf"
  echo ""
  echo "---"
  echo ""
} > "$OUTPUT"

echo "🚀 Generating GSDD Snapshot: $OUTPUT"

############################################
# 5–9. Context + Hash + Signature (Isolated)
############################################
(
  TMP_CONTEXT_FILE="$(mktemp)"
  cd "$PROJECT_ROOT"

  find . -maxdepth 4 -not -path '*/.*' \
    -not -path './node_modules/*' \
    -not -path './dist/*' \
    -not -path './.git/*' \
    -not -path "./$OUTPUT" \
    -not -path './scripts/gsdd-snapshot.sh' \
    -not -regex '.*/.*_[0-9]\{8\}_v[0-9]\{3\}\.md' \
    | grep -E '\.(md|ts|tsx|js|jsx|json|sql|html)$' \
    | sort \
    | while read -r file; do
        if [ -s "$file" ]; then
          echo "$file" >> "$TMP_CONTEXT_FILE"

          LANG="text"
          case "${file##*.}" in
            ts|tsx) LANG="typescript" ;;
            js|jsx) LANG="javascript" ;;
            json)   LANG="json" ;;
            sql)    LANG="sql" ;;
            md)     LANG="markdown" ;;
            html)   LANG="html" ;;
          esac

          {
            echo "# FILE: ${file#./}"
            echo '```'"$LANG"
            cat "$file"
            echo
            echo '```'
            echo
            echo "---"
            echo
          } >> "$OUTPUT"
        fi
      done

  CONTEXT_HASH="$(shasum "$TMP_CONTEXT_FILE" | awk '{print $1}')"
  rm -f "$TMP_CONTEXT_FILE"

  SNAPSHOT_SIGNATURE="$(printf "%s|%s|%s" \
    "$CONTEXT_HASH" \
    "$EXECUTION_FINGERPRINT" \
    "$EXECUTOR_ID" \
    | shasum | awk '{print $1}')"

  HMAC_MODE="OFF"
  HMAC_ATTESTATION=""

  if [ -n "${GSDD_HMAC_KEY:-}" ] && command -v openssl >/dev/null 2>&1; then
    HMAC_MODE="ON"
    HMAC_ATTESTATION="$(printf "%s|%s" \
      "$SNAPSHOT_SIGNATURE" \
      "$EXECUTION_FINGERPRINT" \
      | openssl dgst -sha256 -hmac "$GSDD_HMAC_KEY" \
      | awk '{print $2}')"
  fi

  {
    echo
    echo "---"
    echo
    echo "# CONTEXT_HASH: ${CONTEXT_HASH}"
    echo "# SNAPSHOT_SIGNATURE: ${SNAPSHOT_SIGNATURE}"
    echo "# HMAC_MODE: ${HMAC_MODE}"
    [ -n "$HMAC_ATTESTATION" ] && echo "# HMAC_ATTESTATION: ${HMAC_ATTESTATION}"
    echo "# SNAPSHOT_FINALIZED: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  } >> "$OUTPUT"

) &
spinner $!

############################################
# 10. Human View (Golden Output)
############################################
EXECUTED_BY="$(grep '^# EXECUTED_BY:' "$OUTPUT" | tail -n 1 | cut -d' ' -f3-)"
CONTEXT_HASH="$(grep '^# CONTEXT_HASH:' "$OUTPUT" | tail -n 1 | awk '{print $3}')"
SNAPSHOT_SIGNATURE="$(grep '^# SNAPSHOT_SIGNATURE:' "$OUTPUT" | tail -n 1 | awk '{print $3}')"
SNAPSHOT_SIZE="$(du -h "$OUTPUT" | awk '{print $1}')"

echo "📄 Injecting context files..."
echo "------------------------------------------"
echo "✅ Snapshot generated"
echo "📄 Name        : $OUTPUT"
echo "📏 Size        : $SNAPSHOT_SIZE"
echo "🆔 Executor    : $EXECUTED_BY"
echo "🔐 ContextHash : $CONTEXT_HASH"
echo "🔏 Signature   : $SNAPSHOT_SIGNATURE"
echo "------------------------------------------"
echo "🔎 Quick check : ./scripts/gsdd-verify-snapshot.sh $OUTPUT"
