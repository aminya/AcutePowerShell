
# properties of an object
# obj | props
function props($InputObject) {
    if ($InputObject) { $input = $InputObject }
  
    # process the input (from pipeline or parameter)
    $input | Format-List -Property *
}
Export-ModuleMember -Function props

