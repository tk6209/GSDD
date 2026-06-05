#!/bin/bash
set -euo pipefail

############################################
# Spinner
############################################
spinner() {
  local pid=$1
  local spin='|/-\'
  while kill -0 "$pid" 2>/dev/null; do
    for ((i=0; i<${#spin}; i++)); do
      printf "\r[%s] Generating snapshot..." "${spin:$i:1}"
      sleep 0.12
    done
  done
  printf "\r[GSDD] Snapshot complete.                        \n"
}

############################################
# Executor Identity
############################################
resolve_executor_id() {
  if [ -n "${GSDD_EXECUTOR_ID:-}" ]; then echo "$GSDD_EXECUTOR_ID"; return; fi
  if [ -n "${CI:-}" ]; then
    [ -n "${GITHUB_ACTOR:-}" ] && echo "ci:github:${GITHUB_ACTOR}" && return
    [ -n "${GITLAB_USER_LOGIN:-}" ] && echo "ci:gitlab:${GITLAB_USER_LOGIN}" && return
    echo "ci:unknown"; return
  fi
  command -v whoami >/dev/null 2>&1 && echo "local:$(whoami)" && return
  echo "unknown_executor"
}

# Auto-incrementa versão no diretório do script
get_next_version() {
  local script_dir="$1" project_name="$2" date_utc="$3"
  local ver=1
  while [ -f "${script_dir}/${project_name}${date_utc}_v$(printf "%03d" "$ver").md" ]; do
    ver=$((ver + 1))
  done
  printf "v%03d" "$ver"
}

# Prioridade de arquivo — genérico, funciona em qualquer projeto
get_file_priority() {
  local f="$1"
  case "$f" in
    *CLAUDE.md)                                        echo 0 ;;
    *resumo*executivo* | *executive*summary* | *bc*resumo*) echo 1 ;;
    *.log)                                             echo 2 ;;
    *artefato* | *continuidade* | *handoff* | *sop*)   echo 3 ;;
    */00*index*.md)                                    echo 4 ;;
    */00*guia*.md)                                     echo 5 ;;
    *inject*.py | *bc*inject*.py)                      echo 6 ;;
    *extract*.py | *daily*.py)                         echo 7 ;;
    *.sql)                                             echo 10 ;;
    *.py)                                              echo 11 ;;
    *.md)                                              echo 20 ;;
    *)                                                 echo 99 ;;
  esac
}

############################################
# Configuração
############################################
EXECUTOR_ID="$(resolve_executor_id)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_NAME="$(basename "$PROJECT_ROOT" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')"
DATE_UTC="$(date -u +"%Y%m%d")"
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
VERSION="$(get_next_version "$SCRIPT_DIR" "$PROJECT_NAME" "$DATE_UTC")"
OUTPUT_NAME="${PROJECT_NAME}${DATE_UTC}_${VERSION}.md"
OUTPUT_PATH="${SCRIPT_DIR}/${OUTPUT_NAME}"

GIT_REF="$(git rev-parse HEAD 2>/dev/null || echo 'nogit')"
GIT_TAG="$(git describe --tags --exact-match 2>/dev/null || echo 'none')"

# Fingerprint único por execução (usa timestamp completo)
EXECUTION_FINGERPRINT="$(printf "%s|%s|%s|%s" \
  "$PROJECT_NAME" "$TIMESTAMP" "$EXECUTOR_ID" "$GIT_REF" \
  | sha256sum | awk '{print $1}')"

############################################
# Padrões de exclusão (agnósticos)
############################################
GSDD_FRAMEWORK_NAMES="gsdd[0-9]*_v[0-9]*.md|ANNOUNCEMENT.md|assurance.md|auditability.md|integrity.md|traceability.md|spec_contract.md|execution_flow.md|AUTONOMOUS_PERMISSIONS.md|readme.md|README.md"
SNAPSHOT_PATTERN=".*_v[0-9][0-9][0-9]\.md$"
MAX_FILE_BYTES=$((80 * 1024))

############################################
# Seleção e ordenação de arquivos
############################################
TMP_FILES="$(mktemp)"
TMP_EXCLUDED="$(mktemp)"
INCLUDED_COUNT=0
EXCLUDED_COUNT=0

cd "$PROJECT_ROOT"

find . -type f \
  -not -path '*/.git/*' \
  -not -path '*/node_modules/*' \
  -not -path '*/.venv/*' \
  -not -path '*/.env/*' \
  -not -path '*/dist/*' \
  | grep -E '\.(md|sql|py|log)$' \
  | sort \
  | while read -r f; do
      fname="$(basename "$f")"
      rel="${f#./}"

      # Exclui o próprio output
      [ "$fname" = "$OUTPUT_NAME" ] && echo "$rel [self]" >> "$TMP_EXCLUDED" && continue

      # Exclui snapshots anteriores
      echo "$fname" | grep -qE "$SNAPSHOT_PATTERN" && echo "$rel [snapshot]" >> "$TMP_EXCLUDED" && continue

      # Exclui arquivos GSDD de metodologia
      echo "$fname" | grep -qE "^($GSDD_FRAMEWORK_NAMES)$" && echo "$rel [gsdd-framework]" >> "$TMP_EXCLUDED" && continue

      priority="$(get_file_priority "$rel")"
      printf "%02d\t%s\n" "$priority" "$rel" >> "$TMP_FILES"
  done

# Ordena por prioridade e nome
TMP_SORTED="$(mktemp)"
sort -k1,1n -k2,2 "$TMP_FILES" > "$TMP_SORTED"

INCLUDED_COUNT=$(wc -l < "$TMP_SORTED" | tr -d ' ')
EXCLUDED_COUNT=$(wc -l < "$TMP_EXCLUDED" | tr -d ' ')

############################################
# Manifesto
############################################
MANIFEST="## [SNAPSHOT_MANIFEST]
Included files ($INCLUDED_COUNT):"
while IFS=$'\t' read -r pri rel; do
  MANIFEST="${MANIFEST}
  [${pri}] ${rel}"
done < "$TMP_SORTED"

MANIFEST="${MANIFEST}

Excluded files ($EXCLUDED_COUNT):"
head -30 "$TMP_EXCLUDED" | while read -r ex; do
  MANIFEST="${MANIFEST}
  - ${ex}"
done
[ "$EXCLUDED_COUNT" -gt 30 ] && MANIFEST="${MANIFEST}
  ... (+$((EXCLUDED_COUNT - 30)) more)"

############################################
# Header
############################################
{
  echo "# [SYSTEM_PROMPT: GSDD_CORE_V5]"
  echo "# PROJECT: ${PROJECT_NAME}"
  echo "# SNAPSHOT_ID: ${OUTPUT_NAME}"
  echo "# EXECUTED_BY: ${EXECUTOR_ID}"
  echo "# EXECUTION_FINGERPRINT: ${EXECUTION_FINGERPRINT}"
  echo "# GENERATED_AT: ${TIMESTAMP}"
  echo "# PROVENANCE: governed-specification-driven-development"
  echo ""
  echo "## [GOVERNANCE_CONSTRAINTS]"
  echo "- SSOT: This file is the Single Source of Truth."
  echo "- THE_WALL: Architectural boundaries are non-negotiable."
  echo "- NO_SNIPPETS: Only full-file outputs are allowed."
  echo ""
  echo "---"
  echo ""
  echo "$MANIFEST"
  echo ""
  echo "---"
  echo ""
} > "$OUTPUT_PATH"

############################################
# Corpo do snapshot
############################################
(
  cd "$PROJECT_ROOT"
  while IFS=$'\t' read -r pri rel; do
    [ -s "$rel" ] || continue

    # Label
    fname="$(basename "$rel")"
    if [ "$fname" = "CLAUDE.md" ]; then
      echo ""
      echo "## [CRITICAL_CONTEXT: PROJECT_MASTER]"
      echo ""
    elif echo "$rel" | grep -qiE "resumo.executivo|executive.summary|bc.*resumo"; then
      echo ""
      echo "## [CRITICAL_CONTEXT: SUMMARY]"
      echo ""
    else
      echo ""
      echo "# FILE: $rel"
      echo ""
    fi

    fsize="$(wc -c < "$rel")"
    if [ "$fsize" -gt "$MAX_FILE_BYTES" ]; then
      echo '```text'
      head -c "$MAX_FILE_BYTES" "$rel"
      echo ""
      echo "... [TRUNCATED - file is $((fsize / 1024))KB, limit 80KB]"
      echo '```'
    else
      echo '```text'
      cat "$rel"
      echo '```'
    fi

    echo ""
    echo "---"
    echo ""
  done < "$TMP_SORTED"
) >> "$OUTPUT_PATH"

############################################
# Hash e assinatura (SHA256 sobre o corpo)
############################################
(
  # Extrai o bloco a ser assinado
  POS_START="$(grep -n "## \[GOVERNANCE_CONSTRAINTS\]" "$OUTPUT_PATH" | head -1 | cut -d: -f1)"
  BODY_TO_HASH="$(tail -n +"$POS_START" "$OUTPUT_PATH")"

  CONTEXT_HASH="$(printf "%s" "$BODY_TO_HASH" | sha256sum | awk '{print $1}')"

  SNAPSHOT_SIGNATURE="$(printf "%s|%s|%s" \
    "$CONTEXT_HASH" "$EXECUTION_FINGERPRINT" "$EXECUTOR_ID" \
    | sha256sum | awk '{print $1}')"

  HMAC_MODE="OFF"
  HMAC_ATTESTATION=""
  if [ -n "${GSDD_HMAC_KEY:-}" ] && command -v openssl >/dev/null 2>&1; then
    HMAC_MODE="ON"
    HMAC_ATTESTATION="$(printf "%s|%s" "$SNAPSHOT_SIGNATURE" "$EXECUTION_FINGERPRINT" \
      | openssl dgst -sha256 -hmac "$GSDD_HMAC_KEY" | awk '{print $2}')"
  fi

  {
    echo ""
    echo "# CONTEXT_HASH: ${CONTEXT_HASH}"
    echo "# SNAPSHOT_SIGNATURE: ${SNAPSHOT_SIGNATURE}"
    echo "# HMAC_MODE: ${HMAC_MODE}"
    [ -n "$HMAC_ATTESTATION" ] && echo "# HMAC_ATTESTATION: ${HMAC_ATTESTATION}"
    echo "# SNAPSHOT_FINALIZED: ${TIMESTAMP}"
    echo "# FILES_INCLUDED: ${INCLUDED_COUNT}"
    echo "# FILES_EXCLUDED: ${EXCLUDED_COUNT}"
  } >> "$OUTPUT_PATH"

  # Exporta para relatório final
  echo "$CONTEXT_HASH" > /tmp/gsdd_ctx_hash
  echo "$SNAPSHOT_SIGNATURE" > /tmp/gsdd_sig
) &
spinner $!

rm -f "$TMP_FILES" "$TMP_SORTED" "$TMP_EXCLUDED"

############################################
# Relatório final
############################################
CONTEXT_HASH="$(cat /tmp/gsdd_ctx_hash 2>/dev/null || grep '^# CONTEXT_HASH:' "$OUTPUT_PATH" | awk '{print $3}')"
SNAPSHOT_SIGNATURE="$(cat /tmp/gsdd_sig 2>/dev/null || grep '^# SNAPSHOT_SIGNATURE:' "$OUTPUT_PATH" | awk '{print $3}')"
SNAPSHOT_SIZE="$(du -h "$OUTPUT_PATH" | awk '{print $1}')"
rm -f /tmp/gsdd_ctx_hash /tmp/gsdd_sig

echo "------------------------------------------"
echo "SNAPSHOT     : $OUTPUT_NAME"
echo "SIZE         : $SNAPSHOT_SIZE"
echo "FILES IN     : $INCLUDED_COUNT"
echo "FILES OUT    : $EXCLUDED_COUNT"
echo "EXECUTOR     : $EXECUTOR_ID"
echo "FINGERPRINT  : $EXECUTION_FINGERPRINT"
echo "CONTEXT HASH : $CONTEXT_HASH"
echo "SIGNATURE    : $SNAPSHOT_SIGNATURE"
echo "------------------------------------------"
echo ""
echo "Top files by priority:"
head -8 "$TMP_SORTED" 2>/dev/null | while IFS=$'\t' read -r pri rel; do
  echo "  [$pri] $rel"
done || grep -A8 "Included files" "$OUTPUT_PATH" | tail -8
echo ""
echo "Verify: ./scripts/gsdd-verify-snapshot.sh $OUTPUT_PATH"
