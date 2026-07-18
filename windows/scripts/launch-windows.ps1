[CmdletBinding()]
param(
  [int]$Port = 9335,
  [ValidateSet('Auto', 'Official', 'Private')][string]$LaunchMode = 'Auto',
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$PortExplicit = $PSBoundParameters.ContainsKey('Port')
$StartScript = Join-Path $PSScriptRoot 'start-dream-skin.ps1'
$StateRoot = Join-Path $env:LOCALAPPDATA 'CodexDreamSkin'
$ErrorLog = Join-Path $StateRoot 'launch-error.log'

$plan = [ordered]@{
  startScript = $StartScript
  errorLog = $ErrorLog
  promptRestart = $true
  launchMode = $LaunchMode
  port = if ($PortExplicit) { $Port } else { $null }
}
if ($DryRun) {
  $plan | ConvertTo-Json -Compress
  exit 0
}

. (Join-Path $PSScriptRoot 'common-windows.ps1')
$shell = New-Object -ComObject WScript.Shell
try {
  $startParameters = @{ PromptRestart = $true; LaunchMode = $LaunchMode }
  if ($PortExplicit) { $startParameters.Port = $Port }
  & $StartScript @startParameters
  Remove-Item -LiteralPath $ErrorLog -Force -ErrorAction SilentlyContinue
} catch {
  New-Item -ItemType Directory -Path $StateRoot -Force | Out-Null
  $details = ($_ | Out-String)
  try { Write-DreamSkinUtf8FileAtomically -Path $ErrorLog -Content $details } catch {}
  $message = "Dream Skin could not start: $($_.Exception.Message)`r`n`r`nDetails: $ErrorLog"
  [void]$shell.Popup($message, 0, 'Codex Dream Skin', 16)
  exit 1
}
