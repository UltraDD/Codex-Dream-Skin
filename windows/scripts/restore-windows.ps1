[CmdletBinding()]
param(
  [int]$Port = 9335,
  [switch]$DryRun,
  [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$PortExplicit = $PSBoundParameters.ContainsKey('Port')
$RestoreScript = Join-Path $PSScriptRoot 'restore-dream-skin.ps1'
$StateRoot = Join-Path $env:LOCALAPPDATA 'CodexDreamSkin'
$ErrorLog = Join-Path $StateRoot 'restore-error.log'

if ($DryRun) {
  [ordered]@{ restoreScript = $RestoreScript; errorLog = $ErrorLog } | ConvertTo-Json -Compress
  exit 0
}

. (Join-Path $PSScriptRoot 'common-windows.ps1')
$shell = New-Object -ComObject WScript.Shell
try {
  $restoreParameters = @{ RestoreBaseTheme = $true; PromptRestart = $true; Uninstall = $Uninstall }
  if ($PortExplicit) { $restoreParameters.Port = $Port }
  & $RestoreScript @restoreParameters
  Remove-Item -LiteralPath $ErrorLog -Force -ErrorAction SilentlyContinue
} catch {
  New-Item -ItemType Directory -Path $StateRoot -Force | Out-Null
  $details = ($_ | Out-String)
  try { Write-DreamSkinUtf8FileAtomically -Path $ErrorLog -Content $details } catch {}
  $message = "Dream Skin could not be restored: $($_.Exception.Message)`r`n`r`nDetails: $ErrorLog"
  [void]$shell.Popup($message, 0, 'Codex Dream Skin', 16)
  exit 1
}
