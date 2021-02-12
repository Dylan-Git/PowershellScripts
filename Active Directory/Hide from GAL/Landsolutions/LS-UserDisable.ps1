Write-Host -ForegroundColor Yellow "Remove user account from GAL and from all AD Groups`n#-------------------------------------------------#"

# Find AD user
$User = read-host -Prompt "Enter the username of the account"
$Account = Get-ADUser -Filter {samaccountname -like $User} | Select name

# If user account in AD and multiple users not returned
If((Get-ADUser -Filter {samaccountname -like $User}) -and (Get-ADUser -Filter {samaccountname -like $User}).PSTypeNames -notcontains "System.Array"){ 
    
    $Account = Get-ADUser -Filter {samaccountname -like $User}

    # Hide from GAL
    Set-ADUser $Account -Replace @{msExchHideFromAddressLists=$True}
    Set-ADUser $Account -Clear @("showInAddressBook")
    Set-ADUser $Account -Replace @{mailnickname="$User"}
    Get-ADUser -Filter {samaccountname -like $User} -Properties name,msExchHideFromAddressLists,showInAddressBook,mailnickname | select name,msExchHideFromAddressLists,showInAddressBook,mailnickname
 
    # Remove from Ad groups and make a report of permissions in c:\temp\$User-Report.txt
    (Get-ADUser $Account -properties *).memberof | Out-file c:\temp\$User-Report.txt
    Explorer.exe c:\temp\$User-Report.txt
    Get-AdPrincipalGroupMembership -Identity $Account | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $Account -Confirm -Verbose
}
Else{ Write-Host -ForegroundColor Red "Unable to find $User in AD or multiple user accounts matched the entered username.`n"; $Account | %{ Write-Host -ForegroundColor Red $_.Name}}