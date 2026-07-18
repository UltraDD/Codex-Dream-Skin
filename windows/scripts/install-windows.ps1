[CmdletBinding()]
param(
  [int]$Port = 9335,
  [switch]$DryRun,
  [switch]$NoLaunch
)

$ErrorActionPreference = 'Stop'
$PortExplicit = $PSBoundParameters.ContainsKey('Port')
$WindowsRoot = Split-Path -Parent $PSScriptRoot
$InstallScript = Join-Path $PSScriptRoot 'install-dream-skin.ps1'
$LaunchScript = Join-Path $PSScriptRoot 'start-dream-skin.ps1'
$StateRoot = Join-Path $env:LOCALAPPDATA 'CodexDreamSkin'
$ErrorLog = Join-Path $StateRoot 'install-error.log'

$plan = [ordered]@{
  windowsRoot = $WindowsRoot
  installScript = $InstallScript
  launchScript = $LaunchScript
  errorLog = $ErrorLog
  launchAfterInstall = -not $NoLaunch
}
if ($DryRun) {
  $plan | ConvertTo-Json -Compress
  exit 0
}

. (Join-Path $PSScriptRoot 'common-windows.ps1')
$shell = New-Object -ComObject WScript.Shell
try {
  [void]$shell.Popup(
    'Codex Dream Skin will check prerequisites, close Codex with your permission, install shortcuts, and launch the themed app. Click OK to continue.',
    0,
    'Codex Dream Skin',
    64
  )

  $codexInstalls = @(Get-DreamSkinRegisteredCodexInstalls)
  $statePath = Join-Path $StateRoot 'state.json'
  $state = Read-DreamSkinState -Path $statePath
  $savedCandidate = Get-DreamSkinCodexStatePathCandidate -State $state
  if ($null -ne $savedCandidate) { $codexInstalls += $savedCandidate }
  $runningInstalls = @($codexInstalls | Where-Object {
      (Get-DreamSkinCodexProcesses -Codex $_).Count -gt 0
    })
  if ($runningInstalls.Count -gt 0) {
    $confirmed = Confirm-DreamSkinRestart -Message (
      'Codex is still running. Installation must close it before changing the appearance configuration. ' +
      'Unsaved input may be lost. Close Codex and continue?'
    )
    if (-not $confirmed) {
      [void]$shell.Popup('Installation was cancelled. Codex was not changed.', 0, 'Codex Dream Skin', 64)
      exit 0
    }
    foreach ($install in $runningInstalls) {
      Stop-DreamSkinCodex -Codex $install -AllowForce
    }
  }

  $installParameters = @{}
  if ($PortExplicit) { $installParameters.Port = $Port }
  & $InstallScript @installParameters
  if (-not $NoLaunch) {
    $launchParameters = @{ LaunchMode = 'Auto' }
    if ($PortExplicit) { $launchParameters.Port = $Port }
    & $LaunchScript @launchParameters
  }

  $success = if ($NoLaunch) {
    'Codex Dream Skin is installed. Use the desktop shortcut to launch it.'
  } else {
    'Codex Dream Skin is installed and running. Launch, Tray, and Restore shortcuts are on your desktop or Start menu.'
  }
  [void]$shell.Popup($success, 0, 'Codex Dream Skin', 64)
  Remove-Item -LiteralPath $ErrorLog -Force -ErrorAction SilentlyContinue
} catch {
  New-Item -ItemType Directory -Path $StateRoot -Force | Out-Null
  $details = ($_ | Out-String)
  try { Write-DreamSkinUtf8FileAtomically -Path $ErrorLog -Content $details } catch {}
  $message = "Installation failed: $($_.Exception.Message)`r`n`r`nDetails: $ErrorLog"
  [void]$shell.Popup($message, 0, 'Codex Dream Skin', 16)
  exit 1
}
