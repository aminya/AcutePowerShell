function create_shortcuts() {
    param(
        [string]$SourceFolder,
        [string]$TargetFolder,
        [switch]$DryRun
    )

    if ($DryRun) {
        Write-Host "[DRY RUN MODE] No changes will be made" -ForegroundColor Yellow
    }

    # get basename of the source folder
    $SourceFolderBaseName = (Get-Item $SourceFolder).BaseName

    # default the start menu folder to the user's start menu folder
    if (-not $TargetFolder) {
        $TargetFolder = [Environment]::GetFolderPath("StartMenu") + "\Programs\"
    }

    if (-not (Test-Path -Path $TargetFolder)) {
        if ($DryRun) {
            Write-Host "[DRY RUN] Would create directory: $TargetFolder"
        } else {
            New-Item -ItemType Directory -Force -Path $TargetFolder
        }
    }

    # Excluded folder names (case-insensitive)
    $ExcludedFolders = @( "Common Files", "Microsoft", "Windows", "AMD", "Intel", "NVIDIA", "NVIDIA Corporation")

    # Excluded file names (case-insensitive)
    $ExcludedFiles = @( "ins", "setup")

    $AppFiles = Get-ChildItem -Path $SourceFolder -Recurse -Filter *.exe
    $WshShell = New-Object -ComObject WScript.Shell

    $StartMenuPath = [Environment]::GetFolderPath("StartMenu")
    
    # Get all existing shortcuts in Start Menu and read their target paths
    $ExistingShortcuts = Get-ChildItem -Path $StartMenuPath -Recurse -Filter *.lnk -ErrorAction SilentlyContinue
    $ExistingShortcutTargets = @{}
    $WshShellForReading = New-Object -ComObject WScript.Shell
    foreach ($ShortcutFile in $ExistingShortcuts) {
        try {
            $Shortcut = $WshShellForReading.CreateShortcut($ShortcutFile.FullName)
            $TargetPath = $Shortcut.TargetPath
            if ($TargetPath) {
                $ExistingShortcutTargets[$TargetPath] = $ShortcutFile.FullName
            }
        } catch {
            # Skip shortcuts that can't be read
        }
    }
    
    foreach ($App in $AppFiles) {
        # Skip any exe with unins in the name
        if ($ExcludedFiles | Where-Object { $App.Name -ilike "*$_*" }) {
            continue
        }
        
        # Get the top-level folder name (first subfolder under SourceFolder)
        $RelativePath = $App.DirectoryName.Substring($SourceFolder.Length).TrimStart('\')
        $TopFolder = if ($RelativePath) {
            $RelativePath.Split('\')[0]
        } else {
            $SourceFolderBaseName
        }
        
        # Skip excluded folders
        if ($ExcludedFolders | Where-Object { $TopFolder -ilike "*$_*" }) {
            Write-Host "Skipping '$($App.Name)' as it is in an excluded folder: $TopFolder" -ForegroundColor DarkYellow
            continue
        }
        
        # Create folder structure based on top folder
        $AppTargetFolder = Join-Path $TargetFolder $TopFolder
        
        # Skip if the folder already exists
        if (Test-Path -Path $AppTargetFolder) {
            Write-Host "Skipping '$($App.Name)' as it already exists in: $AppTargetFolder" -ForegroundColor DarkYellow
            continue
        }
        
        New-Item -ItemType Directory -Force -Path $AppTargetFolder | Out-Null

        # Check if a shortcut pointing to the same target path already exists in Start Menu
        if ($ExistingShortcutTargets.ContainsKey($App.FullName)) {
            Write-Host "Skipping '$($App.Name)' as it already exists at: $($ExistingShortcutTargets[$App.FullName])" -ForegroundColor DarkYellow
            continue
        }
        
        # Create a shortcut for each executable found
        $ShortcutPath = Join-Path $AppTargetFolder "$($App.BaseName).lnk"
        if ($DryRun) {
            Write-Host "Would create: $ShortcutPath -> $($App.FullName)" -ForegroundColor Green
        } else {
            $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
            $Shortcut.TargetPath = $App.FullName
            $Shortcut.WorkingDirectory = $App.DirectoryName
            $Shortcut.Save()
            Write-Host "Created: $ShortcutPath -> $($App.FullName)" -ForegroundColor Green
        }
    }
}
Export-ModuleMember -Function create_shortcuts