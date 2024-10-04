
# https://www.powershellgallery.com/packages/modern-unix-win/
if (!(Get-Module -ListAvailable -Name modern-unix-win)) {
    Install-Module -Name modern-unix-win
}
Import-Module -Name modern-unix-win

# https://www.powershellgallery.com/packages/UnixLike (which, touch, grep, etc.)
if (!(Get-Module -ListAvailable -Name UnixLike)) {
    Install-Module -Name UnixLike
}
Import-Module -Name UnixLike

# https://www.powershellgallery.com/packages/Find-String/ (ack, grep)
if (!(Get-Module -ListAvailable -Name Find-String)) {
    Install-Module -Name Find-String
}
Import-Module -Name Find-String
new-alias -Name ack -Value Find-String

# https://www.powershellgallery.com/packages/gsudo/ (gsudo, sudo)
# install via choco
new-alias -Name sudo -Value gsudo
