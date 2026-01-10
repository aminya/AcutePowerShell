function create_shortcuts() {
    param(
        [string]$SourceFolder,
        [string]$TargetFolder
    )

    # get basename of the source folder
    $SourceFolderBaseName = (Get-Item $SourceFolder).BaseName

    # default the start menu folder to the user's start menu folder
    if (-not $TargetFolder) {
        $TargetFolder = [Environment]::GetFolderPath("StartMenu") + "\Programs\$SourceFolderBaseName"
    }

    if (-not (Test-Path -Path $TargetFolder)) {
        New-Item -ItemType Directory -Force -Path $TargetFolder
    }

    $AppFiles = Get-ChildItem -Path $SourceFolder -Recurse -Filter *.exe
    $WshShell = New-Object -ComObject WScript.Shell

    $StartMenuPath = [Environment]::GetFolderPath("StartMenu")
    
    # Get all existing shortcuts in Start Menu
    $ExistingShortcuts = Get-ChildItem -Path $StartMenuPath -Recurse -Filter *.lnk -ErrorAction SilentlyContinue
    $ExistingShortcutNames = @{}
    foreach ($Shortcut in $ExistingShortcuts) {
        $ExistingShortcutNames[$Shortcut.BaseName] = $Shortcut.FullName
    }
    
    foreach ($App in $AppFiles) {
        # Skip any exe with unins in the name
        if ($App.Name -ilike "*unins*") {
            continue
        }
        
        # Check if a shortcut with the same name already exists in Start Menu
        if ($ExistingShortcutNames.ContainsKey($App.BaseName)) {
            Write-Host "Skipping $($App.Name) - shortcut already exists at: $($ExistingShortcutNames[$App.BaseName])"
            continue
        }
        
        # Create a shortcut for each executable found
        $ShortcutPath = "$TargetFolder\$($App.BaseName).lnk"
        $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
        $Shortcut.TargetPath = $App.FullName
        $Shortcut.WorkingDirectory = $App.DirectoryName
        $Shortcut.Save()
        Write-Host "Created shortcut for: $($App.Name)"
    }
}
Export-ModuleMember -Function create_shortcuts