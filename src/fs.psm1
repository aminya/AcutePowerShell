# Get the size of the files in a folder
function ls_size($folder) {
    # https://www.spguides.com/check-file-size-using-powershell/
    Get-ChildItem $folder -recurse | Select-Object Name, @{Name="KiloBytes";Expression={"{0:F2}" -f ($_.length/1KB)}}
}
Export-ModuleMember -Function ls_size

# Dump a binary
function dump_bin($file) {
    dumpbin.exe -all $file | out-file ($file + ".txt")
}
Export-ModuleMember -Function dump_bin
