#!/usr/bin/env bash
set -euo pipefail

# ============================================
# GSDD — Snapshot Verification (Read-Only)
# File: gsdd-verify-snapshot.sh
#
# Guarantees:
#   - read-only
#   - zero mutation
#   - zero generation
#
# Supported:
#   - Hash-based verification (default)
#   - Optional HMAC attestation (enterprise)
#   - Release tag enforcement (tag-based trust)
# ============================================

SNAPSHOT_FILE="${1:-}"
MODE="${GSDD_VERIFY_MODE:-default}"   # default | strict (optional)
FAILURES=0
WARNINGS=0

if [[ -z "${SNAPSHOT_FILE}" ]]; then
  echo "❌ Usage: gsdd-verify-snapshot.sh <snapshot_file>"
  exit 1
fi

if [[ ! -f "${SNAPSHOT_FILE}" ]]; then
  echo "❌ Snapshot file not found: ${SNAPSHOT_FILE}"
  exit 1
fi

# --------------------------------------------
# Helpers
# --------------------------------------------
upper() { printf '%s' "$1" | tr '[:lower:]' '[:upper:]'; }

get_field_last() {
  # usage: get_field_last "FIELD_NAME"
  # expects lines like: "# FIELD_NAME: value"
  grep "^# ${1}:" "${SNAPSHOT_FILE}" | tail -n 1 | sed -E "s/^# ${1}:[[:space:]]*//"
}

has_field() {
  grep -q "^# ${1}:" "${SNAPSHOT_FILE}"
}

fail() {
  echo "❌ FAIL: $1"
  FAILURES=$((FAILURES+1))
}

warn() {
  echo "⚠️  WARN: $1"
  WARNINGS=$((WARNINGS+1))
}

# --------------------------------------------
# 1) Extract declared metadata (from snapshot SSOT)
# --------------------------------------------
PROJECT="$(get_field_last "PROJECT" || true)"
SNAPSHOT_ID="$(get_field_last "SNAPSHOT_ID" || true)"
EXECUTED_BY="$(get_field_last "EXECUTED_BY" || true)"
EXECUTION_FINGERPRINT_DECL="$(get_field_last "EXECUTION_FINGERPRINT" || true)"
RELEASE_TAG="$(get_field_last "RELEASE_TAG" || true)"

CONTEXT_HASH_DECL="$(get_field_last "CONTEXT_HASH" || true)"
SNAPSHOT_SIGNATURE_DECL="$(get_field_last "SNAPSHOT_SIGNATURE" || true)"

HMAC_MODE="$(get_field_last "HMAC_MODE" || true)"
HMAC_ATTESTATION_DECL="$(get_field_last "HMAC_ATTESTATION" || true)"

# Optional (future): SNAPSHOT_SEAL / LEDGER fields
SNAPSHOT_SEAL_DECL="$(get_field_last "SNAPSHOT_SEAL" || true)"
LEDGER_REF_DECL="$(get_field_last "LEDGER_REF" || true)"

echo "🔍 Verifying GSDD Snapshot ($(upper "$MODE") mode): ${SNAPSHOT_FILE}"
echo "------------------------------------------"

# Required minimal fields (current generator guarantees these)
if [[ -z "${PROJECT}" || -z "${SNAPSHOT_ID}" || -z "${EXECUTED_BY}" || -z "${EXECUTION_FINGERPRINT_DECL}" || -z "${CONTEXT_HASH_DECL}" ]]; then
  fail "Missing required snapshot fields. Required: PROJECT, SNAPSHOT_ID, EXECUTED_BY, EXECUTION_FINGERPRINT, CONTEXT_HASH"
fi

# --------------------------------------------
# 2) Verify Snapshot Signature (must exist in our current chain)
# --------------------------------------------
if [[ -z "${SNAPSHOT_SIGNATURE_DECL}" ]]; then
  fail "SNAPSHOT_SIGNATURE missing"
else
  SNAPSHOT_SIGNATURE_OBS="$(
    printf "%s|%s|%s" \
      "${CONTEXT_HASH_DECL}" \
      "${EXECUTION_FINGERPRINT_DECL}" \
      "${EXECUTED_BY}" \
    | shasum | awk '{print $1}'
  )"

  if [[ "${SNAPSHOT_SIGNATURE_DECL}" != "${SNAPSHOT_SIGNATURE_OBS}" ]]; then
    fail "SNAPSHOT_SIGNATURE mismatch (declared != observed)"
    echo "   Declared : ${SNAPSHOT_SIGNATURE_DECL}"
    echo "   Observed : ${SNAPSHOT_SIGNATURE_OBS}"
  else
    echo "✅ Snapshot signature verified"
  fi
fi

# --------------------------------------------
# 3) Release snapshots require HMAC (tag-based trust)
# --------------------------------------------
# Generator writes: "# RELEASE_TAG: none" or "# RELEASE_TAG: vX.Y.Z"
if [[ -n "${RELEASE_TAG}" && "${RELEASE_TAG}" != "none" ]]; then
  if [[ "${HMAC_MODE}" != "ON" ]]; then
    fail "Release snapshot (tag=${RELEASE_TAG}) without HMAC"
  fi
fi

# --------------------------------------------
# 4) Optional SNAPSHOT_SEAL verification (strong tamper evidence)
# --------------------------------------------
if [[ -n "${SNAPSHOT_SEAL_DECL}" && "${SNAPSHOT_SEAL_DECL}" != "none" ]]; then
  SNAPSHOT_SEAL_OBS="$(
    sed '/^# CONTEXT_HASH:/,$d' "${SNAPSHOT_FILE}" | shasum | awk '{print $1}'
  )"

  if [[ "${SNAPSHOT_SEAL_DECL}" != "${SNAPSHOT_SEAL_OBS}" ]]; then
    fail "SNAPSHOT_SEAL mismatch"
    echo "   Declared : ${SNAPSHOT_SEAL_DECL}"
    echo "   Observed : ${SNAPSHOT_SEAL_OBS}"
  else
    echo "✅ Snapshot seal verified"
  fi
else
  warn "SNAPSHOT_SEAL not present — tamper evidence limited to declared-field consistency"
fi

# --------------------------------------------
# 5) Optional HMAC attestation verification
# --------------------------------------------
if [[ "${HMAC_MODE}" == "ON" ]]; then
  if [[ -z "${HMAC_ATTESTATION_DECL}" ]]; then
    fail "HMAC_MODE is ON but HMAC_ATTESTATION is missing"
  fi

  if [[ -z "${GSDD_HMAC_KEY:-}" ]]; then
    fail "HMAC verification requires GSDD_HMAC_KEY in environment"
  fi

  if ! command -v openssl >/dev/null 2>&1; then
    fail "HMAC verification requires 'openssl' but it is not available"
  fi

  if [[ -n "${SNAPSHOT_SIGNATURE_DECL}" && -n "${GSDD_HMAC_KEY:-}" ]] && command -v openssl >/dev/null 2>&1; then
    HMAC_OBS="$(
      printf "%s|%s" "${SNAPSHOT_SIGNATURE_DECL}" "${EXECUTION_FINGERPRINT_DECL}" \
      | openssl dgst -sha256 -hmac "${GSDD_HMAC_KEY}" \
      | awk '{print $2}'
    )"

    if [[ "${HMAC_ATTESTATION_DECL}" != "${HMAC_OBS}" ]]; then
      fail "HMAC attestation mismatch"
      echo "   Declared : ${HMAC_ATTESTATION_DECL}"
      echo "   Observed : ${HMAC_OBS}"
    else
      echo "✅ HMAC attestation verified"
    fi
  fi
else
  echo "ℹ️  HMAC mode is OFF — hash-based verification only"
fi

# --------------------------------------------
# 6) Optional Ledger enforcement (future hook)
# --------------------------------------------
# If you want hard enforcement now, flip WARN->FAIL here once ledger exists.
if [[ -z "${LEDGER_REF_DECL}" || "${LEDGER_REF_DECL}" == "none" ]]; then
  warn "Ledger reference not declared (LEDGER_REF missing)"
fi

# --------------------------------------------
# Final verdict
# --------------------------------------------
echo "------------------------------------------"
if [[ "${FAILURES}" -gt 0 ]]; then
  echo "❌ Snapshot verification FAILED (${FAILURES} fail, ${WARNINGS} warn)"
  exit 1
fi

echo "✅ Snapshot verification PASSED (${WARNINGS} warn)"
echo "   Project   : ${PROJECT}"
echo "   Snapshot  : ${SNAPSHOT_ID}"
echo "   Executor  : ${EXECUTED_BY}"
echo "------------------------------------------"
