$ErrorActionPreference = 'Stop'

$CachedScriptPath = Join-Path $PSScriptRoot '..' 'src' 'msvc_cached.psm1'

if (-not (Test-Path -LiteralPath $CachedScriptPath -PathType Leaf)) {
    throw "Expected the cached MSVC loader at $CachedScriptPath."
}

function global:Enter-VsDevShell {
    throw 'The cached loader must not call Enter-VsDevShell.'
}

$env:PATH = 'C:\AcutePowerShell-TestMarker'
$env:INCLUDE = $null
$env:LIB = $null
$env:LIBPATH = $null
$env:VSCMD_ARG_TGT_ARCH = $null
$env:VSCMD_ARG_HOST_ARCH = $null

Import-Module $CachedScriptPath -Force
enable_msvc_2022_cached

if ($env:VSCMD_ARG_TGT_ARCH -ne 'x64') {
    throw "Expected the cached target architecture to be x64, got '$env:VSCMD_ARG_TGT_ARCH'."
}

if ($env:VSCMD_ARG_HOST_ARCH -ne 'x64') {
    throw "Expected the cached host architecture to be x64, got '$env:VSCMD_ARG_HOST_ARCH'."
}

if ([string]::IsNullOrWhiteSpace($env:VCTOOLSINSTALLDIR)) {
    throw 'Expected the cached MSVC tool directory to be loaded.'
}

if ($env:PATH -notlike '*C:\AcutePowerShell-TestMarker*') {
    throw 'Expected the cached loader to preserve the caller PATH.'
}

if ($env:PATH -notlike '*\VC\Tools\MSVC\*') {
    throw 'Expected the cached MSVC paths to be added to PATH.'
}

Write-Output 'PASS: cached MSVC environment loads without Enter-VsDevShell and preserves PATH.'
