function truncate_wal {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$DirectoryPath,

        [Parameter()]
        [int]$IntervalMinutes = 5,

        [Parameter()]
        [double]$MaxWalSizeMB = 10.0,

        [Parameter()]
        [string]$SqliteExePath = "sqlite3",

        [Parameter()]
        [switch]$Recurse,

        [Parameter()]
        [switch]$Once
    )

    if (-not (Test-Path -LiteralPath $DirectoryPath -PathType Container)) {
        throw "Directory not found or is not a directory: $DirectoryPath"
    }

    Write-Host "Starting SQLite Directory WAL Trim" -ForegroundColor Cyan
    Write-Host "Target Directory   : $DirectoryPath"
    Write-Host "Truncate Threshold : $MaxWalSizeMB MB"
    Write-Host "Recursive Search   : rg always searches recursively (-Recurse retained: $Recurse)"
    Write-Host "Execution Mode     : $(if ($Once) { 'Single Run' } else { "Loop every $IntervalMinutes min" })"
    Write-Host "Press Ctrl+C to stop.`n"

    if (-not (Get-Command rg -ErrorAction SilentlyContinue)) {
        throw "The rg executable was not found on PATH. Install ripgrep or provide it on PATH."
    }

    Write-Host "Discovering database files with rg..." -ForegroundColor Yellow
    $rgResults = @(
        & rg `
            --max-depth 3 `
            --files `
            --hidden `
            --glob '*.db' `
            --glob '*.sqlite' `
            --glob '*.sqlite3' `
            --glob '!node_modules/**' `
            --glob '!target/**' `
            --glob '!build/**' `
            --glob '!dist/**' `
            --glob '!out/**' `
            --glob '!.cache/**' `
            --glob '!.git/**' `
            --glob '!.venv/**' `
            --glob '!venv/**' `
            --glob '!__pycache__/**' `
            --glob '!.tox/**' `
            --glob '!.mypy_cache/**' `
            --glob '!.pytest_cache/**' `
            --glob '!.ruff_cache/**' `
            --glob '!coverage/**' `
            --glob '!.next/**' `
            --glob '!.turbo/**' `
            --glob '!bower_components/**' `
            -- $DirectoryPath 2>&1
    )
    Write-Output $rgResults
    $rgExitCode = $LASTEXITCODE

    if ($rgExitCode -gt 1) {
        $rgDiagnostic = @(
            $rgResults |
                ForEach-Object { $_.ToString().Trim() } |
                Where-Object { $_ }
        ) -join [Environment]::NewLine

        if (-not $rgDiagnostic) {
            $rgDiagnostic = 'no diagnostic output'
        }

        throw "rg failed while searching '$DirectoryPath' (exit code $rgExitCode): $rgDiagnostic"
    }

    if ($rgExitCode -eq 1) {
        $rgResults = @()
    }

    $databaseFiles = @(
        $rgResults |
            ForEach-Object {
                $candidatePath = $_.ToString().Trim()

                if (-not $candidatePath) {
                    return
                }

                if (-not (Test-Path -LiteralPath $candidatePath -PathType Leaf)) {
                    $candidatePath = Join-Path $DirectoryPath $candidatePath
                }

                if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
                    (Resolve-Path -LiteralPath $candidatePath).Path
                }
            } |
            Sort-Object -Unique
    )
    $walPaths = @($databaseFiles | ForEach-Object { "$_-wal" })

    do {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Host "[$timestamp] Checking discovered WAL files..." -ForegroundColor Yellow

        $activeWalFound = $false

        foreach ($walPath in $walPaths) {
            if (-not (Test-Path -LiteralPath $walPath -PathType Leaf)) {
                continue
            }

            $activeWalFound = $true
            $walItem = Get-Item -LiteralPath $walPath
            # Remove trailing '-wal' to resolve the actual database file path
            $dbPath = $walPath.Substring(0, $walPath.Length - 4)

            if (-not (Test-Path -LiteralPath $dbPath -PathType Leaf)) {
                Write-Warning "  Found orphan WAL without matching DB file: $walPath"
                continue
            }

            $walSizeMB = [math]::Round($walItem.Length / 1MB, 2)
            $mode = if ($walSizeMB -ge $MaxWalSizeMB) { "TRUNCATE" } else { "PASSIVE" }
            $dbName = Split-Path $dbPath -Leaf

            Write-Host "  [$dbName] WAL Size: ${walSizeMB} MB -> PRAGMA wal_checkpoint($mode)..." -NoNewline

            try {
                $rawResult = & $SqliteExePath $dbPath "PRAGMA wal_checkpoint($mode);" 2>&1

                if ($LASTEXITCODE -eq 0) {
                    if (Test-Path -LiteralPath $walPath) {
                        $newSizeMB = [math]::Round((Get-Item -LiteralPath $walPath).Length / 1MB, 2)
                        Write-Host " Done. (New size: ${newSizeMB} MB)" -ForegroundColor Green

                        if ($mode -eq "TRUNCATE" -and $newSizeMB -ge $walSizeMB) {
                            Write-Warning "    [!] TRUNCATE did not reduce size for $dbName. An active reader lock may be open."
                        }
                    } else {
                        Write-Host " Done. (WAL file fully removed)" -ForegroundColor Green
                    }
                } else {
                    Write-Host " Failed." -ForegroundColor Red
                    Write-Warning "    SQLite Output: $rawResult"
                }
            } catch {
                Write-Host " Error." -ForegroundColor Red
                Write-Error "    Execution error on $dbName $_"
            }
        }

        if (-not $activeWalFound) {
            Write-Host "  No active .db-wal files found." -ForegroundColor Gray
        }

        if (-not $Once) {
            Write-Host "Sleeping for $IntervalMinutes minute(s)...`n" -ForegroundColor Gray
            Start-Sleep -Seconds ($IntervalMinutes * 60)
        }

    } while (-not $Once)
}

Export-ModuleMember -Function truncate_wal
