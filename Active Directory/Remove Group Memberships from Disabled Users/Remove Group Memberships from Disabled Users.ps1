Foreach ($User in get-aduser -Filter {Enabled -eq "False"}){
$User = $User.SamAccountName
Write-Host $User

(get-aduser $User -properties *).memberof | Out-file c:\temp\$User-Report.txt

Get-AdPrincipalGroupMembership -Identity $User | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $User -Confirm
}