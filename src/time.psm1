if (!(Get-Module -ListAvailable -Name Benchmark)) {
    Install-Module -Name Benchmark -Scope CurrentUser
}

# Benchmark a script and return the ms it took.
# it runs the script once
# btime { node -v }
function btime() {
    param(
        [ScriptBlock]$ScriptBlock
    )
    ( Measure-Command -Expression $ScriptBlock )
}
Export-ModuleMember -Function btime

# Benchmark a script
# it runs the script 10 times
# benchmark { node -v }
function benchmark() {
    param(
        [ScriptBlock]$ScriptBlock
    )
    Measure-These -Count 10 -ScriptBlock $ScriptBlock
}
Export-ModuleMember -Function benchmark
