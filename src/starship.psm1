# if config does not exist, copy it
if (!(Test-Path -Path "~/.config/starship.toml"))
{
    Copy-Item -Path "$PSScriptRoot/src/starship.toml" -Destination "~/.config/starship.toml"
}
Invoke-Expression (& "C:\Program Files\starship\bin\starship" init powershell)
