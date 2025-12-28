function rmrf($path) {
    if (test-path $path) {
        rm -r -force $path
    }
}
Export-ModuleMember -Function rmrf


# Get the size of the files in a folder
function ls_size($folder, $exclude) {
    # https://www.spguides.com/check-file-size-using-powershell/
    $files = Get-ChildItem $folder -recurse -exclude $exclude
    $files | Select-Object Name, @{Name="KiloBytes";Expression={"{0:F3}" -f ($_.length/1KB)}}

    $sum = 0.0
    foreach($file in $files) {
        $sum += $file.length
    }
    echo "---------------------"
    echo "Sum size is $($sum/1KB)"
}
Export-ModuleMember -Function ls_size

# Dump a binary
function dump_bin($file) {
    dumpbin.exe -all $file | out-file ($file + ".txt")
}
Export-ModuleMember -Function dump_bin

# broot extension
function br {
    $outcmd = new-temporaryfile
    broot.exe --outcmd $outcmd $args
    if (!$?) {
        remove-item -force $outcmd
        return $lastexitcode
    }

    $command = get-content $outcmd
    if ($command) {
        # workaround - paths have some garbage at the start
        $command = $command.replace("\\?\", "", 1)
        invoke-expression $command
    }
    remove-item -force $outcmd
}
Export-ModuleMember -Function br

function rm_empty_folders($path = ".") {
    # Get all directories recursively, excluding .git folders
    $directories = Get-ChildItem -Path $path -Directory -Recurse -Force | Where-Object { $_.Name -ne ".git" }

    # Filter directories that are empty (no items inside)
    $emptyDirectories = $directories | Where-Object { (Get-ChildItem $_.FullName -Force | Measure-Object).Count -eq 0 }

    # Display results and delete empty folders
    if ($emptyDirectories.Count -gt 0) {
        Write-Host "Found $($emptyDirectories.Count) empty folder(s):" -ForegroundColor Yellow
        $emptyDirectories | ForEach-Object {
            $relativePath = $_.FullName | Resolve-Path -Relative
            Write-Host "Deleting: $relativePath"
            Remove-Item $_.FullName -Force -Recurse
        }
        Write-Host "Successfully deleted $($emptyDirectories.Count) empty folder(s)" -ForegroundColor Green
    } else {
        Write-Host "No empty folders found in the current directory and subdirectories." -ForegroundColor Green
    }
}
Export-ModuleMember -Function rm_empty_folders
