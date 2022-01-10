# AcutePowerShell

Various PowerShell scripts

## Usage:

Clone the repository

```ps1
git clone https://github.com/aminya/AcutePowerShell
cd AcutePowerShell
```

Now run the script:

```ps1
Import-Module ./index.psm1 -DisableNameChecking
```

### Add it to your profile:

After you cloned the repository, open your profile:

```ps1
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
notepad $PROFILE
```

Append the script to the profile

```ps1
Import-Module "path-you-cloned-the-repo/index.psm1" -DisableNameChecking
```

# List of the commands this add:
```
props
get
which
whichall
rmrf
ls_size
dump_bin
br
find_symlink
set_symlink_target
replace_symlink_target
abspath
wget
btime
benchmark
git_rm_merged
git_reset
git_up
video_replace_audio
video_extract_audio
cmake_configure
cmake_build
```


# Documentation

Now the following functions are available in your session:

### Object:

- `props`:
  properties of an object

```ps1
obj | props
```

- `get`:
  get property of an object

```ps1
obj | get propname
```

### Which:

- `which`:
  list only the first one

```ps1
which clang
```

- `whichall`:
  lists all of the programs

```ps1
whichall clang
```

### Symlink:

- `find_symlink`
  Get the symbolic links in a folder

```ps1
find_symlink .
find_symlink . --recursive
```

- `set_symlink_target`
  Set the target for a symbolic link

```ps1
set_symlink_target path target
set_symlink_target ./folder1/mylink ./folder2/mylink
```

- `replace_symlink_target`
  Replaces the target of a symbolic link. It replaces the old part of the target with the new part

```ps1
replace_symlink_target path old new
replace_symlink_target ./folder1/mylink folder1 folder2
```

### Path:

- `abspath`:
  [normalize a path](https://stackoverflow.com/questions/495618/how-to-normalize-a-path-in-powershell)

# Benchmark

- `btime`:
  Benchmark a script and return the time it took.
  it runs the script once

```ps1
btime { node -v }
```

- `benchmark`:
  Benchmark a script

```ps1
benchmark { node -v }
```

You can change the count number by passing a number as the 2nd parameter

```ps1
benchmark { node -v } 20
```

- `Measure-These`:

https://www.powershelladmin.com/wiki/PowerShell_benchmarking_module_built_around_Measure-Command

# Git:

- `git_rm_merged`:
  Remove the merged git branch

Go to the root of the git repo and then:

```ps1
git_rm_merged
```

- `git_reset`:
  Git fetch and reset --hard

```ps1
git_reset
```

Specifying repo and branch:

```ps1
git_reset("upstream", "master")
```

- `git_up`:
  rebase current branch with remote branch
  git_up [remote=upstream] [branch=master]

```ps1
git_up
```

```ps1
git_up origin master
```

# Media

-`video_replace_audio`:
Batch replace the audio of video files in the current folder

```ps1
video_replace_audio
```

```ps1
video_replace_audio mp4 mp3
```

-`video_extract_audio`:

Batch extract the audio of video files in the current folder

```ps1
video_extract_audio
```

```ps1
video_extract_audio mp4 mp3
```
