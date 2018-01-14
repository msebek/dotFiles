# dotfiles.ps1
# Symlink and copy files into the correct places.

# Running this script will clone a copy of the repo into ~\.dotfiles, if the repo is not already
# located there.

#New-Item -ItemType SymbolicLink -Path ~\_vimrc -Value C:\workspace\dotFiles\link\_vimrc
#New-Item -ItemType SymbolicLink -Path ~\_bashrc2 -Value C:\workspace\dotFiles\link\_bashrc2

get-childitem ~\.dotfiles\link -recurse | % { $_.FullName }

New-Item -ItemType SymbolicLink -Path ~\_vimrc -Value ~\.dotfiles\link\_vimrc
New-Item -ItemType SymbolicLink -Path ~\.gitconfig -Value ~\.dotfiles\link\.gitconfig
New-Item -ItemType SymbolicLink -Path ~\_bashrc2 -Value ~\.dotfiles\link\_bashrc2
