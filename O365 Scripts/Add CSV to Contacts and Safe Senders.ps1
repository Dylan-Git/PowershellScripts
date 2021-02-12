# Connect to Exchange
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Credential -Authentication Basic –AllowRedirection
Import-PSSession $Session		

# Import CSV
$csv = import-csv (read-host -prompt "CSV File Path")
$Users = @()


# Format CSV data into usable objects
Foreach($i in $csv){
    If($i -eq ""){ Continue }
    
    $First = ($i.First)
    $First = $First.Trim()   
    $Last = ($i.Last)
    $Last = $Last.Trim()
    $Email = $i.Email

    $Users+=(
        [pscustomobject]@{
            First=$First
            Last=$Last
            Email=$Email
        }
    )

}

#Get Current Allowed Senders
$PolicyName = "whitelist"
$AllowedSenders = (Get-HostedContentFilterPolicy -Identity $PolicyName).AllowedSenders


# Add to contacts and allowed senders
$Users | ForEach-Object { 
    
    $DisplayName = ($_.First+" "+$_.Last)
    $Email = $_.Email


    # Add Mail Contact and set them to hidden from the GAL
    If(! (Get-MailContact -Identity ($_.Email) -ErrorAction SilentlyContinue)){
        New-MailContact -Name $DisplayName -DisplayName $DisplayName -LastName $_.Last -FirstName $_.Name -ExternalEmailAddress $_.Email
    }
    Else { Write-Host -ForegroundColor Gray "$DisplayName already exists" }

    
    # Add to allowed senders to upload after
    $ErrorActionPreference = "SilentlyContinue"​
    $AllowedSenders += $Email
}

# Update the Allowed senders list
Set-HostedContentFilterPolicy -Identity $PolicyName -AllowedSenders $AllowedSenders
Get-HostedContentFilterPolicy -Identity $PolicyName | select AllowedSenders | ft

Pause​​

