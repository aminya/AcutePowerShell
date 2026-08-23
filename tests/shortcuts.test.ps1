$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot '..' 'src' 'fs.psm1') -Force
Import-Module (Join-Path $PSScriptRoot '..' 'src' 'shortcuts.psm1') -Force

$TestRoot = Join-Path ([IO.Path]::GetTempPath()) "AcutePowerShell-shortcuts-$([guid]::NewGuid())"
$SourceFolder = Join-Path $TestRoot 'Source'
$TargetFolder = Join-Path $TestRoot 'Target'
$WhatIfSourceFolder = Join-Path $TestRoot 'WhatIfSource'
$WhatIfTargetFolder = Join-Path $TestRoot 'WhatIfTarget'

try {
    New-Item -ItemType Directory -Path (Join-Path $SourceFolder 'Vendor') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $TargetFolder 'Stale') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $TargetFolder 'Keep') -Force | Out-Null
    Set-Content -Path (Join-Path $TargetFolder 'Keep\marker.txt') -Value 'keep'
    New-Item -ItemType File -Path (Join-Path $SourceFolder 'Vendor\App.exe') -Force | Out-Null

    create_shortcuts -SourceFolder $SourceFolder -TargetFolder $TargetFolder

    if (Test-Path -LiteralPath (Join-Path $TargetFolder 'Stale')) {
        throw 'Expected empty target folders to be removed.'
    }

    if (-not (Test-Path -LiteralPath (Join-Path $TargetFolder 'Keep\marker.txt'))) {
        throw 'Expected non-empty target folders to be preserved.'
    }

    if (-not (Test-Path -LiteralPath (Join-Path $TargetFolder 'Vendor\App.lnk'))) {
        throw 'Expected the shortcut to be created after empty-folder cleanup.'
    }

    New-Item -ItemType Directory -Path (Join-Path $WhatIfSourceFolder 'Vendor') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $WhatIfTargetFolder 'Stale') -Force | Out-Null
    New-Item -ItemType File -Path (Join-Path $WhatIfSourceFolder 'Vendor\App.exe') -Force | Out-Null

    create_shortcuts -SourceFolder $WhatIfSourceFolder -TargetFolder $WhatIfTargetFolder -WhatIf

    if (-not (Test-Path -LiteralPath (Join-Path $WhatIfTargetFolder 'Stale'))) {
        throw 'Expected -WhatIf to preserve empty target folders.'
    }

    if (Test-Path -LiteralPath (Join-Path $WhatIfTargetFolder 'Vendor\App.lnk')) {
        throw 'Expected -WhatIf not to create shortcuts.'
    }

    Write-Output 'PASS: empty target folders are cleaned and -WhatIf is non-destructive.'
}
finally {
    if (Test-Path -LiteralPath $TestRoot) {
        Remove-Item -LiteralPath $TestRoot -Recurse -Force
    }
}
