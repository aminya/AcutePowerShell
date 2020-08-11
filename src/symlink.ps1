
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
