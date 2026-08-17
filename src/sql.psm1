function Start-SqliteWalMonitor {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DatabasePath,

        [Parameter()]
        [int]$IntervalMinutes = 15,

        [Parameter()]
        [double]$MaxWalSizeMB = 10.0,

        [Parameter()]
        [string]$SqliteExePath = "sqlite3"
    )

    if (-not (Test-Path $DatabasePath)) {
        throw "Database file not found: $DatabasePath"
    }

    $walPath = "$DatabasePath-wal"

    Write-Host "Starting SQLite WAL monitor for: $DatabasePath" -ForegroundColor Cyan
    Write-Host "Check interval: $IntervalMinutes minute(s) | Truncate threshold: $MaxWalSizeMB MB"
    Write-Host "Press Ctrl+C to stop.`n"

    while ($true) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if (Test-Path $walPath) {
            $walItem = Get-Item $walPath
            $walSizeMB = [math]::Round($walItem.Length / 1MB, 2)

            # Escalate to TRUNCATE if file exceeds threshold, otherwise PASSIVE
            $mode = if ($walSizeMB -ge $MaxWalSizeMB) { "TRUNCATE" } else { "PASSIVE" }

            Write-Host "[$timestamp] WAL Size: ${walSizeMB} MB -> Running PRAGMA wal_checkpoint($mode)..." -NoNewline

            try {
                # Executes SQLite CLI command. Output format: 0|busy|log|checkpointed
                $rawResult = & $SqliteExePath $DatabasePath "PRAGMA wal_checkpoint($mode);" 2>&1

                if ($LASTEXITCODE -eq 0) {
                    $newSizeMB = [math]::Round((Get-Item $walPath).Length / 1MB, 2)
                    Write-Host " Done. (New size: ${newSizeMB} MB)" -ForegroundColor Green

                    if ($mode -eq "TRUNCATE" -and $newSizeMB -ge $walSizeMB) {
                        Write-Warning "  [!] TRUNCATE did not reduce size. An active read lock in the external app may be blocking it."
                    }
                } else {
                    Write-Host " Failed." -ForegroundColor Red
                    Write-Warning "  SQLite Output: $rawResult"
                }
            } catch {
                Write-Host " Error." -ForegroundColor Red
                Write-Error "  Could not run sqlite3 command: $_"
            }
        } else {
            Write-Host "[$timestamp] No WAL file present." -ForegroundColor Gray
        }

        Start-Sleep -Seconds ($IntervalMinutes * 60)
    }
}
Export-ModuleMember -Function Start-SqliteWalMonitor

function Start-SqliteWalMonitorDirectory {
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

    if (-not (Test-Path $DirectoryPath)) {
        throw "Directory not found: $DirectoryPath"
    }

    Write-Host "Starting SQLite Directory WAL Trim" -ForegroundColor Cyan
    Write-Host "Target Directory   : $DirectoryPath"
    Write-Host "Truncate Threshold : $MaxWalSizeMB MB"
    Write-Host "Recursive Search   : $Recurse"
    Write-Host "Execution Mode     : $(if ($Once) { 'Single Run' } else { "Loop every $IntervalMinutes min" })"
    Write-Host "Press Ctrl+C to stop.`n"

    do {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Host "[$timestamp] Scanning for active WAL files..." -ForegroundColor Yellow

        $gciParams = @{
            Path   = $DirectoryPath
            Filter = "*-wal"
            File   = $true
        }
        if ($Recurse) { $gciParams.Recurse = $true }

        $walFiles = Get-ChildItem @gciParams

        if (-not $walFiles -or $walFiles.Count -eq 0) {
            Write-Host "  No active .db-wal files found." -ForegroundColor Gray
        } else {
            foreach ($walItem in $walFiles) {
                $walPath = $walItem.FullName
                # Remove trailing '-wal' to resolve the actual database file path
                $dbPath = $walPath.Substring(0, $walPath.Length - 4)

                if (-not (Test-Path $dbPath)) {
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
                        if (Test-Path $walPath) {
                            $newSizeMB = [math]::Round((Get-Item $walPath).Length / 1MB, 2)
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
        }

        if (-not $Once) {
            Write-Host "Sleeping for $IntervalMinutes minute(s)...`n" -ForegroundColor Gray
            Start-Sleep -Seconds ($IntervalMinutes * 60)
        }

    } while (-not $Once)
}

Export-ModuleMember -Function Start-SqliteWalMonitorDirectory
