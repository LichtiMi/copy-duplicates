<#

copy-duplicates.ps1

Description
-----------
Script kopiert im Verzeichnisbaum doppelt vorkommende Dateien (Dateien, bei denen eine Zahl in Klammer angegeben ist)
aller Unterverzeichnisse mit deren Struktur in das neu angelegte Verzeichnis ".DOUBLE"

Datum           Author      Changes
---------------------------------------------------------------------
02.12.2020      LichtiMi    Basisversion

#>

# Variablendefinition
#--------------------
$ls_targetdir=".DOUBLE"
$ls_currentdir=[string](Get-Location)
$i=0

# Seite löschen
#--------------
Clear-Host

# Zielverzeichnis anlegen
#------------------------
if(!(Test-Path -Path $ls_targetdir )){
    New-Item -Path $ls_targetdir -ItemType Directory
}

#$Filelist = (Get-ChildItem -Recurse | Where-Object { $_.FullName -match '.*\([23456789]\)' })
$lfil_Filelist = (Get-ChildItem -Recurse | Where-Object { $_.FullName -match '- Kopie' })
$ll_numfiles = $lfil_Filelist.Count

# Dateien verschieben
#Get-ChildItem -Recurse | Where-Object { $_.FullName -match '.*\([23456789]\)' } | ForEach-Object { 
$lfil_Filelist | ForEach-Object { 

    [System.IO.FileInfo]$lfil_Destination = (Join-Path -Path $ls_currentdir"\"$ls_targetdir -ChildPath $_.FullName.Substring( $ls_currentdir.Length ) )

    #Write-Host -NoNewline $_.FullName " -> " $lfil_Destination.FullName
    Move-Item -WhatIf -Path $_.FullName -Destination $lfil_Destination.FullName

    $i++
    [int]$li_percent = $i / $ll_numFiles * 100

    Write-Progress -Activity "Moving $_.FullName -> $lfil_Destination ($li_percent %)" -status $_  -PercentComplete $li_percent -verbose

}

Write-Host "Current directory: " $ls_currentdir
Write-Host "Anzahl der Dateien: " $ll_numfiles

<#
$SourceFolder = "D:\queries\"
$targetFolder = "G:\queries\"
$numFiles = (Get-ChildItem -Path $SourceFolder -Filter *.TXT).Count
$i=0

Clear-Host;

Write-Host 'This script will copy ' $numFiles ' files from ' $SourceFolder ' to ' $targetFolder
Read-host -prompt 'Press enter to start copying the files'

Get-ChildItem -Path $SourceFolder -Filter *.TXT | ForEach-Object { 
    [System.IO.FileInfo]$destination = (Join-Path -Path $targetFolder -ChildPath $_.Name.replace("_","\"))

   if(!(Test-Path -Path $destination.Directory )){
    New-item -Path $destination.Directory.FullName -ItemType Directory 
    }
    [int]$percent = $i / $numFiles * 100

    copy-item -Path $_.FullName -Destination $Destination.FullName
    Write-Progress -Activity "Copying ... ($percent %)" -status $_  -PercentComplete $percent -verbose
    $i++
}
Write-Host 'Total number of files read from directory '$SourceFolder ' is ' $numFiles
Write-Host 'Total number of files that was copied to '$targetFolder ' is ' $i
Read-host -prompt "Press enter to complete..."
clear-host;
#>

