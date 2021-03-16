# Remove the merged git branch
# Go to the root of the git repo and then:
# git-rm-merged
function git-rm-merged {
 git branch --merged |
   ForEach-Object { $_.Trim() } |
   Where-Object {$_ -NotMatch "^\*"} |
   Where-Object {-not ( $_ -Like "*master" )} |
   ForEach-Object { git branch -d $_ }
}

# Git fetch and reset --hard
# git-reset
# git-reset("upstream", "master")
function git-reset {
  param(
    [string]$repo = "upstream",
    [string]$branch = "master"
  )
  git fetch $repo
  git reset --hard "$repo/$branch"
}

# rebase current branch with remote branch
# git-up [remote=upstream] [branch=master]
function git-up {
  param(
    [string]$remote = "upstream",
    [string]$branch = "master"
  )
  git fetch $remote
  git rebase "$remote/$repo"
}


