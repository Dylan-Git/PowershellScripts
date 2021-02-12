$csv = import-csv "\\F12EDMDC01\USERS\dgrove\Documents\New folder\rig-us.csv"

$csv
Foreach($i in $csv){
        
    $Last = ($i.Last).Split(",")[0]
    $Last = $Last.Split(" ")[1]
    $Firstpre = ($i.Last).Split(",")[1]
    $First = $Firstpre.Split("	")[0]
    $First = $First.Split(" ")[1]
    $Email = $Firstpre.Split("	")[1]
    
    $i.Email = $Email 
    $i.Last = $Last
    $i.First = $First

    }

# Add Mail Contants from CSV
$Csv | % { New-MailContact -Name ($_.First+" "+$_.Last) -DisplayName ($_.First+" "+$_.Last) -LastName $_.Last -Confirm -FirstName $_.Name -ExternalEmailAddress $_.Email -verbose }

#Add to Group
$identity = (Get-DistributionGroup "rigtechs@citadeldrilling.com").id
$csv | % {Write-host -ForegroundColor Yellow ("Adding "+$_.First+" "+$_.Last); Add-DistributionGroupMember -Identity $identity -Member (Get-MailContact $_.Email).id -Verbose }