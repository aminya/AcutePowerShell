
# Get the symbolik links in a folder
# example:
# Find-Symlink .
# Find-Symlink . --recursive
function Find-Symlink() {

    [CmdletBinding()]
  
    param(
        [string]$Path,
        $recursive
    )
  
    if (-not (Test-Path $Path -PathType 'Container')) {
        throw "$($Path) is not a valid folder"
    }
    $Current = Get-Item .
    function Test-ReparsePoint($File) {
        if ([bool]($File.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            $File
        }
        else {
            $FALSE
        }
        return
    }
    cd $Path
  
    if ($recursive) {
        # Recurse through all files and folders, suppressing error messages.
        # Return any file/folder that is actually a symbolic link.
        ls -Force -Recurse -ErrorAction SilentlyContinue | ? { Test-ReparsePoint($_) }
    }
    else {
        ls -Force -ErrorAction SilentlyContinue | ? { Test-ReparsePoint($_) }
    }
  
    cd $Current
  
}
Export-ModuleMember -Function Find-Symlink
  
# Set the target for a symbolik link
# Set-Symlink-Target path target
# Set-Symlink-Target ./folder1/mylink ./folder2/mylink
function Set-Symlink-Target() {
    
    param(
        [string]$Path,
        [string]$Target
    )
  
    New-Item -ItemType Junction -Path "__temp__" -Target $Target
    Remove-Item $Path
    Move-Item "__temp__" $Path
}
Export-ModuleMember -Function Set-Symlink-Target
 

# Replaces the target of a symbolik link. It replaces the old part of the target with the new part
# Replace-Symlink-Target path old new
# Replace-Symlink-Target ./folder1/mylink folder1 folder2 
function Replace-Symlink-Target() {
    
    param(
        [string]$path,
        [string]$old,
        [string]$new
    )
  
    $Current = Get-Item .
    cd $path
  
    $allFiles = (Find-Symlink $path)
    foreach ($file in $allFiles) {
        $target = ($file | get target)
        $name = ($file | get name)
        if ($target -match $old) {
            $target = ($target).replace($old, $new)
            if (Test-Path $target) {
                New-Item -ItemType Junction -Path "__temp__" -Target $target
                Remove-Item $name
                Move-Item "__temp__" $name
            }
        }
    }
  
    cd $Current
}
Export-ModuleMember -Function Replace-Symlink-Target
