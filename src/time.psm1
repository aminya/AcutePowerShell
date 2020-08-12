if (!(Get-Module -ListAvailable -Name Benchmark)) {
    Install-Module -Name Benchmark -Scope CurrentUser
}

# Benchmark a script in ms
# in runs the script once
# btime { node -v }
function btime() {
    param(
        [ScriptBlock]$ScriptBlock
    )
    ( Measure-Command -Expression $ScriptBlock ).Milliseconds
}
Export-ModuleMember -Function btime
