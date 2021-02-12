
# Required variables
#-------------------------------------------------------
$csv = import-csv C:\Users\dgrove\Desktop\contacts.csv
$Groupname = "Market 228"

#--------------------------------------------------------

$ErrorActionPreference = "silentlycontinue"

# Connect to Exchange
$Credential = Get-Credential f12admin@subdev.com
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Credential -Authentication Basic –AllowRedirection
Import-PSSession $Session

# Digest CSV
$Users = @()

Foreach($Line in $csv){
   $First = ($Line.owners).split(" ")[0]
   $Last = ($Line.owners).split(" ")[1]
   $Email = $Line.Email
   $Users+=(
        [pscustomobject]@{
            First=$First
            Last=$Last
            Email=$Email
            }
        )
}


# Run O365 commands
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
    $Groups += $Groupname

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