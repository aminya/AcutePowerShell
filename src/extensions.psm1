if (!(Get-Module -ListAvailable -Name Native)) {
    Install-Module -Name Native
}
Import-Module Native

if (!(Get-Module -ListAvailable -Name oh-my-posh)) {
    Install-Module -Name oh-my-posh
}
Set-PoshPrompt -Theme paradox

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
