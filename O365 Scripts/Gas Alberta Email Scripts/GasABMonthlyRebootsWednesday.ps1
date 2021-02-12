[System.Net.ServicePointManager]::SecurityProtocol = 'TLS12'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Date = (Get-Date -Format dd-MM-yyyy)
$EmailFrom = "f12admin@gasalberta.com"
$EmailTo = "dgrove@f12.net"
$SMTPServer = "smtp.office365.com"

$Subject = "[Alert] F12 Monthly Reboots"
$Body = "To All Gas Alberta Staff,

F12 will be performing monthly server and PC reboots this evening, $Date. We recommend you either Sign Off or Restart your PC before leaving for the day today. For 
those with Great Plains/Management Reporter access, please ensure you have fully logged off these applications before you leave today. 

Thank you.​​
"

Send-MailMessage -SmtpServer $SMTPServer -Credential (Get-Credential f12admin@gasalberta.com) -From $EmailFrom -To $EmailTo -Subject $Subject -UseSsl -Body $Body -Priority High