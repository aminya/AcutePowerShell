
# https://www.powershellgallery.com/packages/modern-unix-win/
if (!(Get-Module -ListAvailable -Name modern-unix-win)) {
    Install-Module -Name modern-unix-win
}
Import-Module -Name modern-unix-win

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

