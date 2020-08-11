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
./index.ps1
```

### Add it to your profile:
After you cloned the repository, open your profile:
```ps1
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
notepad $PROFILE
```

Append the script to the profile
```ps1
path-to-index/index.ps1
```

## Functions
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

- `Find-Symlink`
Get the symbolic links in a folder
```ps1
Find-Symlink .
Find-Symlink . --recursive
```

- `Set-SymlinkTarget`
Set the target for a symbolic link
```ps1
Set-SymlinkTarget path target
Set-SymlinkTarget ./folder1/mylink ./folder2/mylink
```

- `Replace-SymlinkTarget`
Replaces the target of a symbolic link. It replaces the old part of the target with the new part
```ps1
Replace-SymlinkTarget path old new
Replace-SymlinkTarget ./folder1/mylink folder1 folder2
```

### Path:

- `abspath`:
[normalize a path](https://stackoverflow.com/questions/495618/how-to-normalize-a-path-in-powershell)
