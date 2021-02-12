$Domain = "alcor.local"
$Username = "alcor\f12admin"
$Password = "" | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
