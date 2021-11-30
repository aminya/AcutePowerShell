if (!(Get-Module -ListAvailable -Name Native)) {
    Install-Module -Name Native
}
Import-Module Native

if (!(Get-Module -ListAvailable -Name posh-git)) {
    Install-Module -Name posh-git
}
Import-Module posh-git

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
if (![ExperimentalFeature]::IsEnabled("Microsoft.PowerShell.Utility.PSManageBreakpointsInRunspace")) { Enable-ExperimentalFeature Microsoft.PowerShell.Utility.PSManageBreakpointsInRunspace }
if (![ExperimentalFeature]::IsEnabled("PSCommandNotFoundSuggestion")) { Enable-ExperimentalFeature PSCommandNotFoundSuggestion }
if (![ExperimentalFeature]::IsEnabled("PSNativePSPathResolution")) { Enable-ExperimentalFeature PSNativePSPathResolution }
if (![ExperimentalFeature]::IsEnabled("PSSubsystemPluginModel")) { Enable-ExperimentalFeature PSSubsystemPluginModel }
if (![ExperimentalFeature]::IsEnabled("PSNativeCommandArgumentPassing")) { Enable-ExperimentalFeature PSNativeCommandArgumentPassing }
if (![ExperimentalFeature]::IsEnabled("PSAnsiRenderingFileInfo")) { Enable-ExperimentalFeature PSAnsiRenderingFileInfo }
if (![ExperimentalFeature]::IsEnabled("PSLoadAssemblyFromNativeCode")) { Enable-ExperimentalFeature PSLoadAssemblyFromNativeCode }

new-alias -Name sudo -Value gsudo