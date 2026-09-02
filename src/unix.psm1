# https://www.powershellgallery.com/packages/gsudo/ (gsudo, sudo)
# install via choco
if (!(Get-Command sudo -ErrorAction SilentlyContinue)) {
    new-alias -Name sudo -Value gsudo
}

# If Git installed add it to path
# C:\Program Files\Git\usr\bin\whoami.exe
if (Test-Path "C:\Program Files\Git\usr\bin\whoami.exe") {
    $env:Path += ";C:\Program Files\Git\usr\bin"
    [System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Process)
}

# coreutils from winget
if ((Test-Path "$env:LOCALAPPDATA\Microsoft\WinGet\Links\")) {
    # add to path
    $env:Path += ";$env:LOCALAPPDATA\Microsoft\WinGet\Links"
    [System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Process)
}

# Git sh and bash aliases
function sh { & "C:\Program Files\Git\bin\sh.exe" @args }
function bash { & "C:\Program Files\Git\bin\bash.exe" @args }

Export-ModuleMember -Function bash
Export-ModuleMember -Function sh