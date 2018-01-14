# Functions to make dealing with dpk's better
$PACKS = "C:\Users\mase\packs"
Function mase-list() {
    $dpkFiles = Get-ChildItem -Path $PACKS -File
    $matching_dpk = $dpkFiles | Where-Object Extension -eq ".dpk"
    Foreach ($dpk in $matching_dpk) {

        $changelistTextFile = $dpk.Directory.FullName + '\'  + $dpk.BaseName + ".txt"
        if((Test-Path $changelistTextFile)) {
            $changelistNumber = Get-Content $changelistTextFile -Raw
        } else {
            $changelistNumber = 0
        }

        # Add custom propery, our change number; -1 default
        $dpk | Add-Member -f -NotePropertyName ChangeListNumber -NotePropertyValue $changelistNumber

    }
    $matching_dpk | Select LastWriteTime,Name,ChangeListNumber | Format-Table -AutoSize
    #return ,$matching_dpk
}


Function mase-checkout() {
    param(
        [string] $packname = $(throw "Packagename must be provided"),
        [string] $sdp_arguments)
    $dpkFiles = Get-ChildItem -Path $PACKS -File | Where-Object Extension -eq ".dpk"
    $matching_dpk = $dpkFiles | Where-Object Name -like *$packname*

    if($matching_dpk.Count -gt 1)
    {
        Write-Host "Provided packname was ambiguous; aborting"
        return ,@()
    }
    # Unpack this dpk
    #@sdp apply $matching_dpk.FullName | Tee-Object -Variable applyOutput
    #&"$env:SDXROOT\tools\sdp.bat apply $($matching_dpk.FullName) $sdp_arguments" | Tee-Object -Variable applyOutput
    sdp apply -l $matching_dpk.FullName "$sdp_arguments" | Tee-Object -Variable applyOutput

    $changelistNumber = $applyOutput | Select-String '-c\ (\d{1,7})' | %{$_.matches[0].Groups[1].Value}
    if(!!$changelistNumber) {
        $outfilename = ($matching_dpk.Directory.FullName + '\'  + $matching_dpk.BaseName + ".txt")
        [system.io.file]::WriteAllText($outfilename, $changelistNumber)
    }
}

# Backup this dpk?
Function mase-update() {
    param(
        [string] $packname = $(throw "Packagename must be provided"))

    $dpkFiles = Get-ChildItem -Path $PACKS -File | Where-Object Extension -eq ".dpk"
    $matching_dpk = $dpkFiles | Where-Object Name -like *$packname*
    if($matching_dpk.Count -gt 1)
    {
        Write-Host "Provided packname was ambiguous; aborting"
        return ,@()
    }

    $changelistNumber = Get-Content ($matching_dpk.Directory.FullName + '\'  + $matching_dpk.BaseName + ".txt") -Raw

    sdp pack $matching_dpk.FullName -c $changelistNumber
}

Function mase-shelve() {
    param(
        [string] $packname = $(throw "Packagename must be provided"))

    $dpkFiles = Get-ChildItem -Path $PACKS -File
    $matching_dpk = $dpkFiles | Where-Object Name -like *$packname* | Where-Object Extension -eq ".dpk"
    if($matching_dpk.Count -gt 1)
    {
        Write-Host "Provided packname was ambiguous; aborting"
        return
    }

    $changelistTextFile = $matching_dpk.Directory.FullName + '\'  + $matching_dpk.BaseName + ".txt"

    $changelistNumber = Get-Content $changelistTextFile -Raw
    sdp pack $matching_dpk.FullName -c $changelistNumber
    sd revert -c $changelistNumber
    # Note: if this screws up, a local copy has been saved to the recycle bin
    sd change -d $changelistNumber

    Remove-Item $changelistTextFile
}

Function mase-new() {
    param(
        [string] $packname = $(throw "Packagename must be provided"),
        [int] $changelistNumber = $(throw "Changelistnumber mut be provided"))

    sdp pack $PACKS\$packname -c $changelistNumber

    $dpkFiles = Get-ChildItem -Path $PACKS -File
    $matching_dpk = $dpkFiles | Where-Object Name -like *$packname*
    $changelistTextFile = $matching_dpk.Directory.FullName + '\'  + $matching_dpk.BaseName + ".txt"
    [system.io.file]::WriteAllText($changelistTextFile, $changelistNumber)
}
