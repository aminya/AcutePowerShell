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

# Benchmark a script in ms
# it runs the script 10 times
# benchmark { node -v }
function benchmark() {
    param(
        [ScriptBlock]$ScriptBlock
    )
    Measure-These -Count 10 -ScriptBlock $ScriptBlock
}
Export-ModuleMember -Function benchmark
