While($true){
$User = Read-host -Prompt "User sAMAccount name (ex. Pre-2000 logon name in account tab)"

(get-aduser $User -properties *).memberof | Out-file c:\temp\$User-Report.txt
explorer.exe c:\temp\$User-Report.txt

Get-AdPrincipalGroupMembership -Identity $User | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $User
}