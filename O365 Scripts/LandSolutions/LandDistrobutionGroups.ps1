# Digest CSV
$csv = import-csv "C:\users\f12admin\Desktop\Groups.csv"
$Users = @()

Foreach($i in $csv){
    If($i -eq ""){ Continue }
        
    $Last = ($i.Name).Split(" ")[1]
    $Last = $Last.Trim()
    $First = ($i.Name).Split(" ")[0]
    Try{$First = $First.Trim()}
    Catch{Continue}
    $Email = $First+$Last[0]+"@landsolutions.ca"

    $Users+=(
        [pscustomobject]@{
            First=$First
            Last=$Last
            Email=$Email
            LSIBentley=$i.'LSI Bentley'
            LSICalgary=$i.'LSI Calgary'
            LSIEdmonton=$i.'LSI Edmonton'
            LSIGrandePrairie=$i.'LSI Grande Prairie'
            LSILampman=$i.'LSI Lampman'
            LSILloyd=$i.'LSI Lloyd'
            LSINewBrunswick=$i.'LSI New Brunswick'
            LSIOntario=$i.'LSI Ontario'
            LSIUSA=$i.'LSI USA'
            LSIAllStaff=$i.'LSI All Staff'
            LSIConfidential=$i.'LSI Confidential'
            BentleyAnalysts=$i.'Bentley Anaysts'
            CalgaryAnalysts=$i.'Calgary Analysts'
            CalgaryGIS=$i.'Calgary GIS'
            CalgaryLandmen=$i.'Calgary Landmen'
            EdmontonAnalysts=$i.'Edmonton  Analysts'
            Health=$i.'Health & Safety'
            LandTRAXXAdmin=$i.'LandTRAXX Admin'
            LeadershipTeam=$i.'Leadership Team'
            LloydAnalysts=$i.'Lloyd Analysts'
            LSIAnalysts=$i.'LSI Analysts'
            LSITelecomm=$i.'LSI Telecomm'
            WesternCanadaLSILandmen=$i.'Western Canada LSI Landmen'
            OntarioAnalysts=$i.'Ontario Analysts'
            SeniorLeadership=$i.'Senior Leadership'
            SurfaceLandManagers=$i.'Surface Land Managers'
            TravelPlan=$i.'Travel Plan'

        }
    )

}


$Users | ForEach-Object { 
    
    $Memberships = Get-Member -InputObject $_ -MemberType NoteProperty | select name,definition
    $DisplayName = ($_.First+" "+$_.Last)
    $Email = $_.Email
    $Groups = @()



    # Add to Groups
    Foreach($Group in $Memberships){
        If($Group.name -eq "First" -or $Group.name -eq "Last" -or $Group.name -eq "Email"){
            Continue
        }
        ElseIf($Group.Definition -like "*TRUE*"){
            $Groups += $Group.Name
        }
    }
    
    
    Foreach ($Group in $Groups){
    $Check = ((Get-DistributionGroupMember -Identity "$Group*" | Where-Object { $_.displayname -like "*$DisplayName*" }))
        If(! $Check.DisplayName -eq $DisplayName){ 
            Add-DistributionGroupMember -Identity (Get-DistributionGroup "$Group*").id -Member $Email
            Write-Host -ForegroundColor Yellow "Added $DisplayName to $Group"
        }
        Else { Write-Host -ForegroundColor Gray ("$DisplayName already in group: $Group") }
        }

}

