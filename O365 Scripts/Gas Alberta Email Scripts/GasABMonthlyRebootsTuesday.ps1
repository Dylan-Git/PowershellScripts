[System.Net.ServicePointManager]::SecurityProtocol = 'TLS12'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Date = (Get-Date -Format dd-MM-yyyy)
$EmailFrom = "f12admin@gasalberta.com"
$EmailTo = "dgrove@f12.net"
$SMTPServer = "smtp.office365.com"

$Subject = "[Alert] F12 Monthly Reboots"
$Body = "To All Gas Alberta Staff,


F12 will be performing monthly server and PC reboots tomorrow evening, $Date. This will require you either Sign Off or Restart your PC before leaving for the day tomorrow. 

We will send a reminder email tomorrow morning for your convenience. Please contact jolt@f12.net or call 403.355.3653 if you have any questions or concerns.

Thank you.
"

Send-MailMessage -SmtpServer $SMTPServer -Credential (Get-Credential f12admin@gasalberta.com) -From $EmailFrom -To $EmailTo -Subject $Subject -UseSsl -Body $Body