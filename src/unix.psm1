
# https://www.powershellgallery.com/packages/modern-unix-win/
if (!(Get-Module -ListAvailable -Name modern-unix-win)) {
    Install-Module -Name modern-unix-win
}
Import-Module -Name modern-unix-win

# https://www.powershellgallery.com/packages/gsudo/ (gsudo, sudo)
# install via choco
new-alias -Name sudo -Value gsudo

# install coreutils via winget
if (!(Get-Command "coreutils" -ErrorAction SilentlyContinue)) {
    winget install uutils.coreutils
}

# Coreutils aliases

# from posh-alias https://www.powershellgallery.com/packages/posh-alias/1.0 Apache-2.0
function Add-Alias($name, $alias) {
    $func = @"
function global:$name {
    `$expr = ('$alias ' + (( `$args | % { if (`$_.GetType().FullName -eq "System.String") { "``"`$(`$_.Replace('``"','````"').Replace("'","``'"))``"" } else { `$_ } } ) -join ' '))
    write-debug "Expression: `$expr"
    Invoke-Expression `$expr
}
"@
    write-debug "Defined function:`n$func"
    $func | iex
}
