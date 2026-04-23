# https://github.com/shaunburdick/token-count

function Get-GitTokenCount {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [Alias("m")]
        [string]$Model = "claude-sonnet-4-6",

        [Parameter()]
        [int]$ThrottleLimit = 15
    )

    if (!(git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Error "Not a git repository."
        return
    }

    $binaries = '\.(png|jpg|jpeg|gif|ico|pdf|exe|dll|so|bin|zip|tar|gz|7z|pyc|class|node|woff|woff2|ttf|eot)$'
    $files = git ls-files | Where-Object { $_ -notmatch $binaries }

    Write-Host "Counting tokens using $Model across $($files.Count) files..." -ForegroundColor Gray

    # Parallel processing: PowerShell waits here until all threads finish
    $results = $files | ForEach-Object -Parallel {
        if (Test-Path $_ -PathType Leaf) {
            try {
                # Get raw content and pipe to your CLI
                $output = Get-Content -Path $_ -Raw -ErrorAction SilentlyContinue | token-count --model $using:Model
                
                # Regex to extract the first integer found in the CLI output
                if ($output -match '(\d+)') {
                    [PSCustomObject]@{
                        File  = $_
                        Count = [int]$matches[1]
                    }
                }
            } catch {
                # Ignore specific file errors to keep the stream clean
            }
        }
    } -ThrottleLimit $ThrottleLimit

    # Output per-file counts to the console
    foreach ($item in $results) {
        Write-Host ("{0,8}  {1}" -f $item.Count, $item.File)
    }

    # FIX: Explicitly sum the 'Count' property of the objects
    $total = ($results | Measure-Object -Property Count -Sum).Sum
    
    Write-Host ("-" * 30)
    Write-Host "TOTAL TOKENS ($Model): $total" -ForegroundColor Cyan
}