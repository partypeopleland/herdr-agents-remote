$ErrorActionPreference = 'Stop'

$appHome = if ($env:HERDR_APP_HOME) { $env:HERDR_APP_HOME } else { Join-Path $HOME '.config\herdr-app' }
if (-not (Test-Path -LiteralPath (Join-Path $appHome 'AGENTS.md'))) {
    throw "Herdr app home not found: $appHome"
}

$stamp = Get-Date -Format 'yyyyMMddHHmmssfff'
$backupRoot = Join-Path $appHome "backups\herdr-agents-remote\$stamp"
$target = Join-Path $appHome 'mods\agents-remote'
if (Test-Path -LiteralPath $target) {
    New-Item -ItemType Directory -Force -Path $backupRoot > $null
    Copy-Item -LiteralPath $target -Destination (Join-Path $backupRoot 'agents-remote') -Recurse
}
New-Item -ItemType Directory -Force -Path $target > $null
Copy-Item -Path (Join-Path $PSScriptRoot 'mod\*') -Destination $target -Recurse -Force

$checker = (Get-Command herdr-app -ErrorAction Stop).Source
$check = Start-Process -FilePath $checker -ArgumentList @('check', ('"' + $target + '"')) -Wait -PassThru -WindowStyle Hidden
if ($check.ExitCode -ne 0) { throw "agents-remote mod check failed (exit $($check.ExitCode))" }

# herdr-app check writes its own gpui-kit.d.ts into the folder; it is a
# runtime artifact (the app rewrites it), not repo content.
Remove-Item -LiteralPath (Join-Path $target 'gpui-kit.d.ts') -ErrorAction SilentlyContinue

"Installed agents-remote to $target"
"Point a layout's agents block at it: { `"content`": { `"mod`": `"agents-remote`" } }"
