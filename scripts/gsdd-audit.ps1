param ([string]$FilePath)

if (-not (Test-Path $FilePath)) { 
    Write-Host "[ERRO] Arquivo nao encontrado." -ForegroundColor Red
    exit 1 
}

# 1. Leitura em UTF8 (Mesmo padrao do Gerador)
$RawText = Get-Content -Path $FilePath -Raw -Encoding UTF8
$utf8 = New-Object System.Text.UTF8Encoding($false)

# 2. Extracao de Metadados
$Finger = ""
if ($RawText -match "# EXECUTION_FINGERPRINT:\s*([a-f0-9]+)") { $Finger = $Matches[1] }

$DeclaredSig = ""
if ($RawText -match "# SNAPSHOT_SIGNATURE:\s*([a-f0-9]+)") { $DeclaredSig = $Matches[1] }

$Executor = ""
if ($RawText -match "# EXECUTED_BY:\s*(.*)") { $Executor = $Matches[1].Trim() }

# 3. Localizacao do Bloco (Ajustado para coincidir com o Gerador v2)
# O Gerador v2 assina a partir do Manifesto ou Constraints ate o final do corpo
$AnchorStart = "## [" 
$AnchorEnd   = "# CONTEXT_HASH:"

$PosStart = $RawText.IndexOf($AnchorStart)
$PosEnd   = $RawText.IndexOf($AnchorEnd)

if ($PosStart -lt 0 -or $PosEnd -lt 0) {
    Write-Host "[ERRO] Tags de integridade nao localizadas." -ForegroundColor Red
    exit 1
}

# Extrai o corpo e garante o Trim() idêntico ao do Snapshot v2
$BodyToValidate = $RawText.Substring($PosStart, $PosEnd - $PosStart).Trim()

# 4. Calculo SHA256
$sha256 = [System.Security.Cryptography.SHA256]::Create()

# Calcula o Hash do Contexto
$ContentHash = [System.BitConverter]::ToString($sha256.ComputeHash($utf8.GetBytes($BodyToValidate))).Replace("-", "").ToLower()

# Calcula a Assinatura (Payload: ContextHash | Fingerprint | Executor)
$FinalPayload = "$ContentHash|$Finger|$Executor"
$CalculatedSig = [System.BitConverter]::ToString($sha256.ComputeHash($utf8.GetBytes($FinalPayload))).Replace("-", "").ToLower()

# 5. Veredito
Write-Host "`n--- GSDD AUDIT REPORT (v3 Sync) ---" -ForegroundColor Cyan
Write-Host "Arquivo  : $(Split-Path $FilePath -Leaf)"

if ($CalculatedSig -eq $DeclaredSig) {
    Write-Host "[OK] INTEGRIDADE VALIDADA: O snapshot v3 e autentico." -ForegroundColor Green
} else {
    Write-Host "[FALHA] DIVERGENCIA DE ASSINATURA!" -ForegroundColor Red
    Write-Host "A assinatura calculada nao bate com a do arquivo."
    Write-Host "Verifique se houve edicao manual ou erro de trim."
    Write-Host "`nCalculada: $CalculatedSig"
    Write-Host "Declarada : $DeclaredSig"
    exit 1
}