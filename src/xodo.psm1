function xodo_cleanup() {
    $packages_dir = "$env:LOCALAPPDATA/Packages"
    # find the XodoDocs package
    $xodo_package = Get-ChildItem -Path $packages_dir -Filter "*XODODOCS*" | Select-Object -First 1
    if ($xodo_package) {
        $xodo_path = $xodo_package.FullName
        Write-Host "Removing XodoDocs package at: $xodo_path" -ForegroundColor Green
        rmrf $xodo_path
    } else {
        Write-Host "XodoDocs package not found in $packages_dir" -ForegroundColor Red
    }
}
Export-ModuleMember -Function xodo_cleanup
