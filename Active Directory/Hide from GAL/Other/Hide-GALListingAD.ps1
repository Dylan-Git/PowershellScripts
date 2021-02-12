$user = read-host -Prompt "Username"
Set-ADUser $user -Replace @{msExchHideFromAddressLists=$true} -Verbose
Set-ADUser $user -Replace @{mailnickname="$user"} -Verbose
Start-ADSyncSyncCycle -PolicyType Delta