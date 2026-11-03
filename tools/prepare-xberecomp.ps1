<#
.SYNOPSIS
  Prepare the XboxXBERecomp SDK revision and patch set required by MKD/MKA.

.DESCRIPTION
  The rollback/native projects depend on changes kept under recomp/patches.
  Building against upstream main directly is not sufficient. This script keeps
  a dedicated checkout under external/XboxXBERecomp, pins it to the SDK base
  used by this project, and applies every xboxxberecomp-*.patch in order.
#>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$sdk = Join-Path $root 'external\XboxXBERecomp'
$patchDir = Join-Path $root 'recomp\patches'
$upstream = 'https://github.com/TGP482/XboxXBERecomp.git'
# Snapshot used by this project before its local rollback/runtime patch series.
$baseCommit = 'e0de3e44d10443c1c9aad512f36baf133cdd4a60'

function Run-Git([string[]]$Args) {
    & git @Args
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Args -join ' ') failed with exit code $LASTEXITCODE"
    }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git was not found on PATH.'
}
if (-not (Test-Path $patchDir)) {
    throw "Patch directory not found: $patchDir"
}

if (-not (Test-Path (Join-Path $sdk '.git'))) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $sdk) | Out-Null
    Write-Host "  cloning XboxXBERecomp -> $sdk"
    Run-Git @('clone', $upstream, $sdk)
}

$head = (& git -C $sdk rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw "Cannot read SDK checkout at $sdk" }

if ($head -ne $baseCommit) {
    $dirty = @(& git -C $sdk status --porcelain)
    if ($LASTEXITCODE -ne 0) { throw "Cannot inspect SDK checkout at $sdk" }
    if ($dirty.Count -ne 0) {
        throw "XboxXBERecomp is at $head with local changes. Expected base $baseCommit. Move/delete external\XboxXBERecomp or clean it before retrying."
    }
    Write-Host "  switching XboxXBERecomp to pinned base $baseCommit"
    Run-Git @('-C', $sdk, 'fetch', 'origin', $baseCommit)
    Run-Git @('-C', $sdk, 'checkout', '--detach', $baseCommit)
}

$patches = @(Get-ChildItem -Path $patchDir -Filter 'xboxxberecomp-*.patch' | Sort-Object Name)
if ($patches.Count -eq 0) { throw "No XboxXBERecomp patches found in $patchDir" }

Write-Host "  applying/verifying $($patches.Count) SDK patches"
foreach ($patch in $patches) {
    & git -C $sdk apply --check --whitespace=nowarn $patch.FullName 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    + $($patch.Name)"
        Run-Git @('-C', $sdk, 'apply', '--whitespace=nowarn', $patch.FullName)
        continue
    }

    # If the reverse patch checks cleanly, this patch is already present.
    & git -C $sdk apply --reverse --check --whitespace=nowarn $patch.FullName 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    = $($patch.Name) (already applied)"
        continue
    }

    throw "Patch does not apply cleanly and is not already applied: $($patch.Name). The SDK checkout is not in the expected state."
}

$required = @(
    'runtime\xdk\dsound.h',
    'runtime\kernel\host_rollback.h'
)
foreach ($relative in $required) {
    if (-not (Test-Path (Join-Path $sdk $relative))) {
        throw "Patched SDK is missing required file: $relative"
    }
}

Write-Host "  patched XboxXBERecomp ready: $sdk"
exit 0
