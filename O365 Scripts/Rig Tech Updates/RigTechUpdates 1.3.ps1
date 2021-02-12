# Connect to Exchange
$CreateEXOPSSession = (Get-ChildItem -Path $env:userprofile -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName
. "$CreateEXOPSSession\CreateExoPSSession.ps1"
Connect-EXOPSSession

# Digest CSV
$csv = import-csv C:\Users\f12admin\Desktop\RigTechUpdates.csv
$Users = @()

$ErrorActionPreference = "silentlycontinue"

Foreach($i in $csv){
    If($i -eq ""){ Continue }
        
    $Last = ($i.Name).Split(",")[0]
    $Last = $Last.Trim()
    $First = ($i.Name).Split(",")[1]
    Try{$First = $First.Trim()}
    Catch{Continue}
    $Email = $i.Email

    $Users+=(
        [pscustomobject]@{
            First=$First
            Last=$Last
            Email=$Email
            RigTechs=$i.RigTechs
            CanadianRigTechs=$i.CanadianRigTechs
            CanamRigTechs=$i.CanamRigTechs
            UsRigTechs=$i.UsRigTechs
        }
    )

}



$Users | ForEach-Object { 
    
    $DisplayName = ($_.First+" "+$_.Last)
    $Groups = @()

    # Add Mail Contact and set them to hidden from the GAL
    If(! (Get-MailContact -Identity ($_.Email) -ErrorAction SilentlyContinue)){
        New-MailContact -Name $DisplayName -DisplayName $DisplayName -LastName $_.Last -FirstName $_.Name -ExternalEmailAddress $_.Email
        Set-MailContact -Identity ($_.Email) -HiddenFromAddressListsEnabled $true -WarningAction SilentlyContinue
        Write-Host -ForegroundColor Yellow ("Set $DisplayName to be hidden from the address list.")
    }
    Else { Write-Host -ForegroundColor Gray "$DisplayName already exists" }

    # Add to Groups
    If($_.RigTechs -eq "TRUE")         { $Groups += "RigTechs" }
    If($_.CanadianRigTechs -eq "TRUE") { $Groups += "CanadianRigTechs" }
    If($_.CanamRigTechs -eq "TRUE")    { $Groups += "CanamRigTechs" }
    If($_.UsRigTechs -eq "TRUE")       { $Groups += "UsRigTechs" }
    
    Foreach ($Group in $Groups){
    $Check = ((Get-DistributionGroupMember -Identity "$Group*" | Where-Object { $_.displayname -eq $DisplayName }))
        If(! $Check.DisplayName -eq $DisplayName){ 
            Add-DistributionGroupMember -Identity (Get-DistributionGroup "$Group*").id -Member $DisplayName 
            Write-Host -ForegroundColor Yellow "Added $DisplayName to $Group"
        }
        Else { Write-Host -ForegroundColor Gray ("$DisplayName already in group: $Group") }
        }

}

Pause