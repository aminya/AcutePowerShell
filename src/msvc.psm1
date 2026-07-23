function enable_msvc_2022() {
    $ORIG_PWD = "$PWD"

    # When pwsh is launched from a bash shell (e.g. Git Bash) that exported
    # functions via `export -f`, bash passes them down as environment variables
    # named `BASH_FUNC_<name>%%` whose values are bash code (`() { ... }`).
    # Enter-VsDevShell processes environment variable values as PowerShell
    # wildcard patterns, and bash syntax like `[[ "$model" != -* ]]` is an
    # invalid wildcard, producing:
    #   Enter-VsDevShell: The specified wildcard character pattern is not valid
    # Strip these leaked bash-function variables before entering the dev shell.
    foreach ($item in Get-ChildItem Env:) {
        if ($item.Name -like 'BASH_FUNC_*' -or $item.Value -like '() {*') {
            [System.Environment]::SetEnvironmentVariable($item.Name, $null, 'Process')
        }
    }

    & {
        Import-Module 'C:/Program Files/Microsoft Visual Studio/2022/Community/Common7\Tools\Microsoft.VisualStudio.DevShell.dll'; 
        Enter-VsDevShell -Arch "amd64" -HostArch "amd64" -VsInstallPath 'C:/Program Files/Microsoft Visual Studio/2022/Community/';
    }
    cd "$ORIG_PWD"
}
Export-ModuleMember -Function enable_msvc_2022

function enable_msvc_18() {
    $ORIG_PWD = "$PWD"

    # When pwsh is launched from a bash shell (e.g. Git Bash) that exported
    # functions via `export -f`, bash passes them down as environment variables
    # named `BASH_FUNC_<name>%%` whose values are bash code (`() { ... }`).
    # Enter-VsDevShell processes environment variable values as PowerShell
    # wildcard patterns, and bash syntax like `[[ "$model" != -* ]]` is an
    # invalid wildcard, producing:
    #   Enter-VsDevShell: The specified wildcard character pattern is not valid
    # Strip these leaked bash-function variables before entering the dev shell.
    foreach ($item in Get-ChildItem Env:) {
        if ($item.Name -like 'BASH_FUNC_*' -or $item.Value -like '() {*') {
            [System.Environment]::SetEnvironmentVariable($item.Name, $null, 'Process')
        }
    }

    & {
        Import-Module 'C:/Program Files/Microsoft Visual Studio/18/Community/Common7\Tools\Microsoft.VisualStudio.DevShell.dll'; 
        Enter-VsDevShell -Arch "amd64" -HostArch "amd64" -VsInstallPath 'C:/Program Files/Microsoft Visual Studio/18/Community/';
    }
    cd "$ORIG_PWD"
}
Export-ModuleMember -Function enable_msvc_18

