function enable_msvc() {
    $ORIG_PWD = $PWD
    & { Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell -Arch amd64 -HostArch amd64 -VsInstallPath "C:/Program Files/Microsoft Visual Studio/2022/Community/" }
    cd $ORIG_PWD
}
Export-ModuleMember -Function enable_msvc
