$User = ''
"Get-ADUser -Filter {cn -eq $User} | Set-ADUser -Replace @{msExchHideFromAddressLists=$true}