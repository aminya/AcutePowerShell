
# properties of an object
# obj | props
function props($InputObject) {
    if ($InputObject) { $input = $InputObject }
  
    # process the input (from pipeline or parameter)
    $input | Format-List -Property *
}
Export-ModuleMember -Function props


# get property of an object
# obj | get propname
function get($property, $obj) {
    if ($obj) { $input = $obj }
  
    $input | Select-Object -ExpandProperty $property
}
Export-ModuleMember -Function get
