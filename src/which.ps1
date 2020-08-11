
# lists all of the programs
# whichall clang
function whichall($name) {
    if ($name) { $input = $name }
    where.exe $input
}
Export-ModuleMember -Function whichall
 
