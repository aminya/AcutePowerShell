
# list only the first one (or all with -a)
# which clang
# which -a clang
function which {
    param(
        [switch]$a,
        [Parameter(ValueFromPipeline=$true, Position=0)]
        [string]$name
    )
    if (-not $name) { $name = $input }
    if ($a) {
        where.exe $name
    } else {
        Get-Command $name | Select-Object -ExpandProperty Path -First 1
    }
}
Export-ModuleMember -Function which
