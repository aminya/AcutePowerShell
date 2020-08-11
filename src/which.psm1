
# lists all of the programs
# whichall clang
function whichall($name) {
    if ($name) { $input = $name }
    where.exe $input
}
Export-ModuleMember -Function whichall
 
# list only the first one
# which clang
function which($name) {
    if ($name) { $input = $name }
    Get-Command $input | Select-Object -ExpandProperty Path
}
Export-ModuleMember -Function which
