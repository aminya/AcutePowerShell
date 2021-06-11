# Get the size of the files in a folder
function ls_size($folder, $exclude) {
    # https://www.spguides.com/check-file-size-using-powershell/
    $files = Get-ChildItem $folder -recurse -exclude $exclude
    $files | Select-Object Name, @{Name="KiloBytes";Expression={"{0:F3}" -f ($_.length/1KB)}}

    $sum = 0.0
    foreach($file in $files) {
        $sum += $file.length
    }
    echo "---------------------"
    echo "Sum size is $($sum/1KB)"
}
Export-ModuleMember -Function ls_size

# Dump a binary
function dump_bin($file) {
    dumpbin.exe -all $file | out-file ($file + ".txt")
}
Export-ModuleMember -Function dump_bin
