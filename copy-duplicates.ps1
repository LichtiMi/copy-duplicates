<#

copy-duplicates.ps1

Description
-----------
Script kopiert im Verzeichnisbaum doppelt vorkommende Dateien (Dateien, bei denen eine Zahl in Klammer angegeben ist)
aller Unterverzeichnisse mit deren Struktur in das neu angelegte Verzeichnis ".DOUBLE"

Datum           Author      Changes
---------------------------------------------------------------------
02.12.2020      LichtiMi    Basisversion
04.12.2020      LichtiMi    Kommentare einfügen
                LichtiMi    Zielpfad anlegen falls er noch nicht existiert
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

# Alle Dateien, die 'Kopie' im Dateinamen haben, ermitteln
# Alternativ kann nach Dateien mit Zalhlen in der Klammer gesucht werden
# '.*\([23456789]\)'
#-----------------------------------------------------------------------
#$lfil_Filelist = (Get-ChildItem -Recurse | Where-Object { $_.FullName -match '- Kopie' })
$lfil_Filelist = (Get-ChildItem -Path ./* -Exclude .DOUBL* | Where-Object { $_.FullName -match '.*\([23456789]\)' })

# Anzahl der Dateien ermitteln
#-----------------------------
$ll_numfiles = $lfil_Filelist.Count

# Dateien verschieben
#--------------------
$lfil_Filelist | ForEach-Object { 

    # Zielpfad für die Datei zusammenstellen
    # Es wird '.DOUBLE' beim aktuellen Pfad eingefügt
    #------------------------------------------------
    [System.IO.FileInfo]$lfil_Destination = (Join-Path -Path $ls_currentdir"\"$ls_targetdir -ChildPath $_.FullName.Substring( $ls_currentdir.Length ) )

    # Zielpfad anlegen falls er noch nicht existiert
    #-----------------------------------------------
    if( !( Test-Path -Path $lfil_Destination.DirectoryName )) {
        New-Item -Path $lfil_Destination.DirectoryName -ItemType Directory | Out-Null
    }

    # Datei verschieben
    #------------------
    #Move-Item -WhatIf -Path $_.FullName -Destination $lfil_Destination.FullName
    Move-Item -Path $_.FullName -Destination $lfil_Destination.FullName 

    # Fortschrittsprozentsatz ermitteln
    #----------------------------------
    $i++
    [int]$li_percent = $i / $ll_numFiles * 100

    # Fortschritt ausgeben
    #---------------------
    Write-Progress -Activity "Moving $_.FullName -> $lfil_Destination ($li_percent %)" -status $_  -PercentComplete $li_percent -verbose

}

# Abschließend Aktuelles Verzeichnis und Anzahl der verschobenen Dateien ausgeben
#--------------------------------------------------------------------------------
Write-Host "Aktuelles Verzeichnis: " $ls_currentdir
Write-Host "Anzahl der verschobenen Dateien: " $ll_numfiles
