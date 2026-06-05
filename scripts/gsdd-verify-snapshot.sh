#!/usr/bin/env bash
set -euo pipefail

# ============================================
# GSDD — Snapshot Verification (Read-Only)
# File: gsdd-verify-snapshot.sh
#
# Guarantees:
#   - read-only, zero mutation
#   - SHA256-based body hash verification
#   - Anchor-aware (SNAPSHOT_MANIFEST or GOVERNANCE_CONSTRAINTS)
#   - Optional HMAC attestation (enterprise)
#   - Release tag enforcement (tag-based trust)
# ============================================

SNAPSHOT_FILE="${1:-}"
MODE="${GSDD_VERIFY_MODE:-default}"
FAILURES=0
WARNINGS=0

if [[ -z "${SNAPSHOT_FILE}" ]]; then
  echo "Usage: gsdd-verify-snapshot.sh <snapshot_file>"
  exit 1
fi

if [[ ! -f "${SNAPSHOT_FILE}" ]]; then
  echo "[ERRO] Snapshot file not found: ${SNAPSHOT_FILE}"
  exit 1
fi

# --------------------------------------------
# Helpers
# --------------------------------------------
get_field() {
  grep "^# ${1}:" "${SNAPSHOT_FILE}" | tail -n 1 | sed -E "s/^# ${1}:[[:space:]]*//"
}

fail() { echo "[FALHA] $1"; FAILURES=$((FAILURES+1)); }
warn() { echo "[AVISO] $1"; WARNINGS=$((WARNINGS+1)); }

# --------------------------------------------
# 1. Extração de metadados
# --------------------------------------------
PROJECT="$(get_field "PROJECT" || true)"
SNAPSHOT_ID="$(get_field "SNAPSHOT_ID" || true)"
EXECUTED_BY="$(get_field "EXECUTED_BY" || true)"
EXECUTION_FINGERPRINT_DECL="$(get_field "EXECUTION_FINGERPRINT" || true)"
RELEASE_TAG="$(get_field "RELEASE_TAG" || true)"
CONTEXT_HASH_DECL="$(get_field "CONTEXT_HASH" || true)"
SNAPSHOT_SIGNATURE_DECL="$(get_field "SNAPSHOT_SIGNATURE" || true)"
HMAC_MODE="$(get_field "HMAC_MODE" || true)"
HMAC_ATTESTATION_DECL="$(get_field "HMAC_ATTESTATION" || true)"
FILES_IN="$(get_field "FILES_INCLUDED" || true)"
FILES_OUT="$(get_field "FILES_EXCLUDED" || true)"
GENERATED_AT="$(get_field "GENERATED_AT" || true)"

echo ""
echo "--- GSDD AUDIT REPORT ---"
echo "Snapshot     : $(basename "$SNAPSHOT_FILE")"
echo "Generated    : $GENERATED_AT"
echo "Executor     : $EXECUTED_BY"
[ -n "$FILES_IN" ]  && echo "Files In     : $FILES_IN"
[ -n "$FILES_OUT" ] && echo "Files Out    : $FILES_OUT"
echo "Fingerprint  : $EXECUTION_FINGERPRINT_DECL"
echo ""

# Validação de campos obrigatórios
if [[ -z "$PROJECT" || -z "$SNAPSHOT_ID" || -z "$EXECUTED_BY" || \
      -z "$EXECUTION_FINGERPRINT_DECL" || -z "$CONTEXT_HASH_DECL" ]]; then
  fail "Campos obrigatorios ausentes: PROJECT, SNAPSHOT_ID, EXECUTED_BY, EXECUTION_FINGERPRINT, CONTEXT_HASH"
fi

# --------------------------------------------
# 2. Recalcula CONTEXT_HASH do corpo do arquivo
#    Âncora primária: ## [SNAPSHOT_MANIFEST]
#    Fallback:        ## [GOVERNANCE_CONSTRAINTS]
# --------------------------------------------
ANCHOR="## [SNAPSHOT_MANIFEST]"
if ! grep -q "## \[SNAPSHOT_MANIFEST\]" "$SNAPSHOT_FILE"; then
  ANCHOR="## [GOVERNANCE_CONSTRAINTS]"
fi

ANCHOR_LINE="$(grep -n "${ANCHOR}" "$SNAPSHOT_FILE" | head -1 | cut -d: -f1)"
FOOTER_LINE="$(grep -n "^# CONTEXT_HASH:" "$SNAPSHOT_FILE" | head -1 | cut -d: -f1)"

if [[ -z "$ANCHOR_LINE" || -z "$FOOTER_LINE" ]]; then
  fail "Ancoras de integridade nao encontradas (SNAPSHOT_MANIFEST / GOVERNANCE_CONSTRAINTS / CONTEXT_HASH)"
  exit 1
fi

BODY_TO_HASH="$(sed -n "${ANCHOR_LINE},${FOOTER_LINE}p" "$SNAPSHOT_FILE" | head -n -1)"
CONTEXT_HASH_OBS="$(printf "%s" "$BODY_TO_HASH" | sha256sum | awk '{print $1}')"

if [[ "$CONTEXT_HASH_OBS" == "$CONTEXT_HASH_DECL" ]]; then
  echo "[OK] Context hash verificado"
else
  fail "CONTEXT_HASH diverge — corpo do arquivo foi alterado"
  echo "  Declarado  : $CONTEXT_HASH_DECL"
  echo "  Calculado  : $CONTEXT_HASH_OBS"
fi

# --------------------------------------------
# 3. Verifica assinatura
# --------------------------------------------
if [[ -z "$SNAPSHOT_SIGNATURE_DECL" ]]; then
  fail "SNAPSHOT_SIGNATURE ausente"
else
  SNAPSHOT_SIGNATURE_OBS="$(printf "%s|%s|%s" \
    "$CONTEXT_HASH_DECL" \
    "$EXECUTION_FINGERPRINT_DECL" \
    "$EXECUTED_BY" \
    | sha256sum | awk '{print $1}')"

  if [[ "$SNAPSHOT_SIGNATURE_DECL" == "$SNAPSHOT_SIGNATURE_OBS" ]]; then
    echo "[OK] Assinatura verificada"
  else
    fail "SNAPSHOT_SIGNATURE nao confere"
    echo "  Declarada  : $SNAPSHOT_SIGNATURE_DECL"
    echo "  Calculada  : $SNAPSHOT_SIGNATURE_OBS"
  fi
fi

# --------------------------------------------
# 4. Release tag requer HMAC
# --------------------------------------------
if [[ -n "$RELEASE_TAG" && "$RELEASE_TAG" != "none" ]]; then
  if [[ "$HMAC_MODE" != "ON" ]]; then
    fail "Snapshot de release (tag=${RELEASE_TAG}) sem HMAC"
  fi
fi

# --------------------------------------------
# 5. HMAC attestation (opcional)
# --------------------------------------------
if [[ "$HMAC_MODE" == "ON" ]]; then
  if [[ -z "$HMAC_ATTESTATION_DECL" ]]; then
    fail "HMAC_MODE=ON mas HMAC_ATTESTATION ausente"
  elif [[ -z "${GSDD_HMAC_KEY:-}" ]]; then
    fail "Verificacao HMAC requer GSDD_HMAC_KEY no ambiente"
  elif ! command -v openssl >/dev/null 2>&1; then
    fail "Verificacao HMAC requer openssl"
  else
    HMAC_OBS="$(printf "%s|%s" "$SNAPSHOT_SIGNATURE_DECL" "$EXECUTION_FINGERPRINT_DECL" \
      | openssl dgst -sha256 -hmac "$GSDD_HMAC_KEY" | awk '{print $2}')"
    if [[ "$HMAC_ATTESTATION_DECL" == "$HMAC_OBS" ]]; then
      echo "[OK] HMAC attestation verificado"
    else
      fail "HMAC attestation nao confere"
      echo "  Declarado  : $HMAC_ATTESTATION_DECL"
      echo "  Calculado  : $HMAC_OBS"
    fi
  fi
else
  echo "[INFO] HMAC_MODE=OFF — verificacao apenas por hash"
fi

# --------------------------------------------
# Veredito final
# --------------------------------------------
echo ""
echo "------------------------------------------"
if [[ "$FAILURES" -gt 0 ]]; then
  echo "[FALHA] Verificacao FALHOU ($FAILURES falha(s), $WARNINGS aviso(s))"
  exit 1
fi

echo "[OK] INTEGRIDADE VALIDADA ($WARNINGS aviso(s))"
echo "   Project  : $PROJECT"
echo "   Snapshot : $SNAPSHOT_ID"
echo "   Executor : $EXECUTED_BY"
echo "------------------------------------------"
