$ErrorActionPreference = 'Stop'

Import-Module (Join-Path (Join-Path $PSScriptRoot '..') 'src\sql.psm1') -Force

$RgCommand = Get-Command rg -CommandType Application -ErrorAction Stop | Select-Object -First 1
$RealRgPath = $RgCommand.Source
if ([string]::IsNullOrWhiteSpace($RealRgPath)) {
    $RealRgPath = $RgCommand.Path
}

$TestRoot = Join-Path ([IO.Path]::GetTempPath()) "AcutePowerShell-sql-$([guid]::NewGuid())"
$DatabaseDirectory = Join-Path (Join-Path $TestRoot 'Nested') '.hidden-database'
$DatabasePath = Join-Path $DatabaseDirectory 'app.db'
$WalPath = "$DatabasePath-wal"
$IgnoreFilePath = Join-Path $TestRoot '.gitignore'
$FakeBin = Join-Path $TestRoot 'bin'
$RgLogPath = Join-Path $TestRoot 'rg.log'
$SqliteLogPath = Join-Path $TestRoot 'sqlite.log'
$OldPath = $env:PATH

try {
    New-Item -ItemType Directory -Path $DatabaseDirectory -Force | Out-Null
    New-Item -ItemType Directory -Path $FakeBin -Force | Out-Null
    [IO.File]::SetAttributes($DatabaseDirectory, [IO.FileAttributes]::Directory -bor [IO.FileAttributes]::Hidden)
    Set-Content -LiteralPath $IgnoreFilePath -Value 'Nested/'
    Set-Content -LiteralPath $DatabasePath -Value 'database'
    Set-Content -LiteralPath $WalPath -Value 'wal'

    Set-Content -LiteralPath (Join-Path $FakeBin 'rg.cmd') -Encoding ascii -Value @"
@echo off
echo called>>"$RgLogPath"
"$RealRgPath" %*
exit /b %errorlevel%
"@

    Set-Content -LiteralPath (Join-Path $FakeBin 'sqlite-test.cmd') -Encoding ascii -Value @"
@echo off
echo %*>>"$SqliteLogPath"
exit /b 0
"@

    $env:PATH = "$FakeBin$([IO.Path]::PathSeparator)$OldPath"

    truncate_wal -DirectoryPath $TestRoot -Recurse -Once -IntervalMinutes 0 -SqliteExePath (Join-Path $FakeBin 'sqlite-test.cmd')

    $rgCalls = @(
        if (Test-Path -LiteralPath $RgLogPath) { Get-Content -LiteralPath $RgLogPath }
    )
    if ($rgCalls.Count -ne 1) {
        throw "Expected rg to discover database files once at startup, but it was called $($rgCalls.Count) time(s)."
    }

    if ($rgCalls[0] -ne 'called') {
        throw "Expected the rg invocation marker, got: $($rgCalls[0])"
    }

    $sqliteCalls = @(
        if (Test-Path -LiteralPath $SqliteLogPath) { Get-Content -LiteralPath $SqliteLogPath }
    )
    if ($sqliteCalls.Count -ne 1) {
        throw "Expected one SQLite checkpoint for the discovered WAL, but got $($sqliteCalls.Count)."
    }

    if ($sqliteCalls[0] -notlike "*$DatabasePath*") {
        throw "Expected SQLite to receive the discovered database path, got: $($sqliteCalls[0])"
    }

    if ($sqliteCalls[0] -notlike '*PRAGMA wal_checkpoint(PASSIVE);*') {
        throw "Expected the default threshold to use PASSIVE checkpointing, got: $($sqliteCalls[0])"
    }

    Write-Output 'PASS: rg discovers nested databases once and the monitor checks their derived WAL paths.'
}
finally {
    $env:PATH = $OldPath

    if (Test-Path -LiteralPath $DatabaseDirectory -PathType Container) {
        [IO.File]::SetAttributes($DatabaseDirectory, [IO.FileAttributes]::Directory)
    }

    if (Test-Path -LiteralPath $TestRoot) {
        Remove-Item -LiteralPath $TestRoot -Recurse -Force
    }
}
