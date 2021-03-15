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
# You can change the count number by passing a number as the 2nd parameter
function benchmark() {
    param(
        [ScriptBlock]$script,
        [int]$count = 10
    )
    Measure-These -Count $count -ScriptBlock $script
}
Export-ModuleMember -Function benchmark
