
# Load posh-git example profile
. 'C:\Users\Matt\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

# Alias gvim to vim
set-alias vim gvim

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
