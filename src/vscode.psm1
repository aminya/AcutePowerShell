function cleanup_vscode_extensions
{
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )

    # Get all subfolders in the specified directory
    $subfolders = Get-ChildItem -Path $FolderPath -Directory

    # Create a hashtable to store folder names and their respective paths
    $folderNameHash = @{}

    foreach ($folder in $subfolders) {

        $Shrink_Folder_Name_Length = [math]::Ceiling($folder.Name.Length * 0.10)
        $Shrink_Folder_Name_Length = $folder.Name.Length - $Shrink_Folder_Name_Length
        $key = $folder.Name.Substring(0, [Math]::Min($Shrink_Folder_Name_Length, $folder.Name.Length))

        if (-not $folderNameHash.ContainsKey($key)) {
            $folderNameHash[$key] = @($folder)
        }
        else {
            $folderNameHash[$key] += $folder
        }
    }

    # List to hold folders to be deleted
    $foldersToDelete = @()

    # Identify the folder with the oldest creation date for each key
    foreach ($key in $folderNameHash.Keys) {
        if ($folderNameHash[$key].Count -gt 1) {
            Write-output ""
            Write-Output "Similar folders for key '$key':"

            # Identify the folder with the oldest creation date
            $oldestFolder = $folderNameHash[$key] | Sort-Object CreationTime | Select-Object -First 1
            $foldersToDelete += $oldestFolder

            foreach ($folder in $folderNameHash[$key]) {
                $modifiedDate = $folder.LastWriteTime
                $createdDate = $folder.CreationTime
                Write-Output ("`t" + $folder.FullName + " (Modified: $modifiedDate, Created: $createdDate)")
            }
        }
    }

    write-host ""
    write-host ""
    write-host ""

    # Delete the folders in $foldersToDelete
    foreach ($folder in $foldersToDelete) {
        Write-Output "Deleting folder: $($folder.FullName)"
        Remove-Item -Path $folder.FullName -Recurse -Force
    }
}
Export-ModuleMember -Function cleanup_vscode_extensions
