
# Get the symbolic links in a folder
# example:
# find_symlink .
# find_symlink . --recursive
function find_symlink() {

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
Export-ModuleMember -Function find_symlink

# Set the target for a symbolic link
# set_symlink_target path target
# set_symlink_target ./folder1/mylink ./folder2/mylink
function set_symlink_target() {

    param(
        [string]$Path,
        [string]$Target
    )

    New-Item -ItemType Junction -Path "__temp__" -Target $Target
    Remove-Item $Path
    Move-Item "__temp__" $Path
}
Export-ModuleMember -Function set_symlink_target


# Replaces the target of a symbolic link. It replaces the old part of the target with the new part
# replace_symlink_target path old new
# replace_symlink_target ./folder1/mylink folder1 folder2
function replace_symlink_target() {

    param(
        [string]$path,
        [string]$old,
        [string]$new
    )

    $Current = Get-Item .
    cd $path

    $allFiles = (find_symlink $path)
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
Export-ModuleMember -Function replace_symlink_target
