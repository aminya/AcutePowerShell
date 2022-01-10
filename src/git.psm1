# Remove the merged git branch
# Go to the root of the git repo and then:
# git_rm_merged
function git_rm_merged {
 git branch --merged |
   ForEach-Object { $_.Trim() } |
   Where-Object {$_ -NotMatch "^\*"} |
   Where-Object {-not ( $_ -Like "*master" )} |
   ForEach-Object { git branch -d $_ }
}

# Git fetch and reset --hard
# git_reset
# git_reset("upstream", "master")
function git_reset {
  param(
    [string]$repo = "upstream",
    [string]$branch = "master"
  )
  git fetch $repo
  git reset --hard "$repo/$branch"
}

# rebase current branch with remote branch
# git_up [remote=upstream] [branch=master]
function git_up {
  param(
    [string]$remote = "upstream",
    [string]$branch = "master"
  )
  git fetch $remote
  git rebase "$remote/$repo"
}


