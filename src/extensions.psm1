if (!(Get-Module -ListAvailable -Name Native)) {
    Install-Module -Name Native
}
Import-Module Native

# https://www.powershellgallery.com/packages/modern-unix-win/
if (!(Get-Module -ListAvailable -Name modern-unix-win)) {
    Install-Module -Name modern-unix-win
}
Import-Module -Name modern-unix-win

if (!(Get-Module -ListAvailable -Name UnixLike)) {
    Install-Module -Name UnixLike
}
Import-Module -Name UnixLike

if (!(Get-Module -ListAvailable -Name Find-String)) {
    Install-Module -Name Find-String
}
Import-Module -Name Find-String
new-alias -Name ack -Value Find-String


# experimental features
if (![ExperimentalFeature]::IsEnabled("PSCommandNotFoundSuggestion")) { Enable-ExperimentalFeature PSCommandNotFoundSuggestion }
if (![ExperimentalFeature]::IsEnabled("PSSubsystemPluginModel")) { Enable-ExperimentalFeature PSSubsystemPluginModel }
if (![ExperimentalFeature]::IsEnabled("PSLoadAssemblyFromNativeCode")) { Enable-ExperimentalFeature PSLoadAssemblyFromNativeCode }

new-alias -Name sudo -Value gsudo


# if config does not exist, copy it
if (!(Test-Path -Path "~/.config/starship.toml")) {
    Copy-Item -Path "$PSScriptRoot/src/starship.toml" -Destination "~/.config/starship.toml"
}
Invoke-Expression (& "C:\Program Files\starship\bin\starship" init powershell)
