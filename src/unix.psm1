
# https://www.powershellgallery.com/packages/modern-unix-win/
if (!(Get-Module -ListAvailable -Name modern-unix-win)) {
    Install-Module -Name modern-unix-win
}
Import-Module -Name modern-unix-win

# https://www.powershellgallery.com/packages/gsudo/ (gsudo, sudo)
# install via choco
new-alias -Name sudo -Value gsudo

# install coreutils via winget
if (!(Get-Command "coreutils" -ErrorAction SilentlyContinue)) {
    winget install uutils.coreutils
}

# Coreutils aliases

# from posh-alias https://www.powershellgallery.com/packages/posh-alias/1.0 Apache-2.0
function Add-Alias($name, $alias) {
    $func = @"
function global:$name {
    `$expr = ('$alias ' + (( `$args | % { if (`$_.GetType().FullName -eq "System.String") { "``"`$(`$_.Replace('``"','````"').Replace("'","``'"))``"" } else { `$_ } } ) -join ' '))
    write-debug "Expression: `$expr"
    Invoke-Expression `$expr
}
"@
    write-debug "Defined function:`n$func"
    $func | iex
}

Add-alias arch "coreutils arch"
Add-alias b2sum "coreutils b2sum"
Add-alias base32 "coreutils base32"
Add-alias base64 "coreutils base64"
Add-alias basename "coreutils basename"
Add-alias basenc "coreutils basenc"
Add-alias cat "coreutils cat"
Add-alias cksum "coreutils cksum"
Add-alias comm "coreutils comm"
# Add-alias cp "coreutils cp"
Add-alias csplit "coreutils csplit"
Add-alias cut "coreutils cut"
Add-alias date "coreutils date"
Add-alias dd "coreutils dd"
Add-alias df "coreutils df"
# Add-alias dir "coreutils dir"
Add-alias dircolors "coreutils dircolors"
Add-alias dirname "coreutils dirname"
Add-alias du "coreutils du"
# Add-alias echo "coreutils echo"
Add-alias env "coreutils env"
Add-alias expand "coreutils expand"
Add-alias expr "coreutils expr"
Add-alias factor "coreutils factor"
Add-alias false "coreutils false"
Add-alias fmt "coreutils fmt"
Add-alias fold "coreutils fold"
Add-alias hashsum "coreutils hashsum"
Add-alias head "coreutils head"
Add-alias hostname "coreutils hostname"
Add-alias join "coreutils join"
Add-alias link "coreutils link"
Add-alias ln "coreutils ln"
Add-alias ls "coreutils ls"
Add-alias md5sum "coreutils md5sum"
Add-alias mkdir "coreutils mkdir"
Add-alias mktemp "coreutils mktemp"
Add-alias more "coreutils more"
Add-alias mv "coreutils mv"
Add-alias nl "coreutils nl"
Add-alias nproc "coreutils nproc"
Add-alias numfmt "coreutils numfmt"
Add-alias od "coreutils od"
Add-alias paste "coreutils paste"
Add-alias pr "coreutils pr"
Add-alias printenv "coreutils printenv"
Add-alias printf "coreutils printf"
Add-alias ptx "coreutils ptx"
Add-alias pwd "coreutils pwd"
Add-alias readlink "coreutils readlink"
Add-alias realpath "coreutils realpath"
Add-alias rm "coreutils rm"
Add-alias rmdir "coreutils rmdir"
Add-alias seq "coreutils seq"
Add-alias sha1sum "coreutils sha1sum"
Add-alias sha224sum "coreutils sha224sum"
Add-alias sha256sum "coreutils sha256sum"
Add-alias sha384sum "coreutils sha384sum"
Add-alias sha512sum "coreutils sha512sum"
Add-alias shred "coreutils shred"
Add-alias shuf "coreutils shuf"
# Add-alias sleep "coreutils sleep"
# Add-alias sort "coreutils sort"
Add-alias split "coreutils split"
Add-alias sum "coreutils sum"
Add-alias sync "coreutils sync"
Add-alias tac "coreutils tac"
Add-alias tail "coreutils tail"
# Add-alias tee "coreutils tee"
Add-alias test "coreutils test"
Add-alias touch "coreutils touch"
Add-alias tr "coreutils tr"
Add-alias true "coreutils true"
Add-alias truncate "coreutils truncate"
Add-alias tsort "coreutils tsort"
Add-alias uname "coreutils uname"
Add-alias unexpand "coreutils unexpand"
Add-alias uniq "coreutils uniq"
Add-alias unlink "coreutils unlink"
Add-alias vdir "coreutils vdir"
Add-alias wc "coreutils wc"
Add-alias whoami "coreutils whoami"
Add-alias yes "coreutils yes"
