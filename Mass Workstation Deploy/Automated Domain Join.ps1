$username = "dc\f12admin"
$password = "Camefoundthem6$"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd

Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter).InterfaceAlias -ServerAddresses "192.168.16.3"
sleep(5)
Add-Computer -DomainName "dc.local" -Credential ($creds) -force -Options JoinWithNewName,AccountCreate -Restart