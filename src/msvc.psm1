function fix_bash_msvc() {
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
}

function enable_msvc($version) {
    $ORIG_PWD = "$PWD"
    $ORIG_VCPKG_ROOT = "$env:VCPKG_ROOT"
    $VS_INSTALL_PATH = "C:/Program Files/Microsoft Visual Studio/$version/Community"

    fix_bash_msvc

    & {
        Import-Module "$VS_INSTALL_PATH/Common7/Tools/Microsoft.VisualStudio.DevShell.dll";
        $null = Enter-VsDevShell -Arch "amd64" -HostArch "amd64" -VsInstallPath "$VS_INSTALL_PATH/";
    }
    cd "$ORIG_PWD"

    # unset vcpkg
    if ($ORIG_VCPKG_ROOT) {
        $env:VCPKG_ROOT = $ORIG_VCPKG_R
    }
    else {
        $env:VCPKG_VISUAL_STUDIO_PATH = $VS_INSTALL_PATH
    }
}

function enable_msvc_2022() {
    enable_msvc 2022
}
Export-ModuleMember -Function enable_msvc_2022

function enable_msvc_18() {
    enable_msvc 18
}
Export-ModuleMember -Function enable_msvc_18

