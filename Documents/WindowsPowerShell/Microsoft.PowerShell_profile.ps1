
# Load posh-git example profile
. 'C:\Users\Matt\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

# Alias gvim to vim
set-alias vim "C:\Program Files (x86)\Vim\vim74\gvim.exe"
set-alias gvim vim

function up1 {
    cd ..;
}
function up2 {
    cd ..\..;
}
function up3 {
    cd ..\..\..;
}
function up4 {
    cd ..\..\..\..;
}
