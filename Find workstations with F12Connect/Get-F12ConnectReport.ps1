# Where f12 is installed (in share notation)
$F12Path = "c$\Program Files (x86)\F12.net\F12Connect"

# Amount of time since last PC logon
$days = 14

$Computers = Get-ADComputer -Filter * -Properties lastlogondate | Where-Object lastlogondate -gt (get-date).AddDays(-$days)
$Date = Get-date -Format dd-MM-yyyy
$Outfile = "C:\F12\logs\$Date-ConnectReport.txt"
$F12Computers = @()
$NonF12Computers = @()
$DisconnectedComputers = @()
$LastPCname="."

Foreach($PC in $Computers){
    $PCname = $PC.Name
    If($PCname -eq $LastPCname){ Continue} # Remove duplicate PCs from AD report

    $TestConnection = Test-Connection $PC.Name -Count 1 -ErrorAction SilentlyContinue -Quiet
    If($TestConnection){
        If(Test-Path -Path "\\$PCname\$F12Path"){
            Write-Host -ForegroundColor Green "$PCname has F12Connect installed."
            $F12Computers += $PCname
            }
        Else{
            Write-Host -ForegroundColor Red "$PCname does not have F12Connect installed."
            $NonF12Computers += $PCname
            }
        }
    else{
        Write-Host -ForegroundColor gray "$PCname is unreachable."
        $DisconnectedComputers += $PCname
        }
    
    $LastPCname = $PCname
}


# Generate report
$Report = "Installed`n------------`n"
foreach($PC in $F12Computers){ $Report += "$PC`n"}
$Report += "`n`nNot Installed`n------------`n"
foreach($PC in $NonF12Computers){ $Report += "$PC`n"}
$Report += "`n`nDisconnected`n------------`n"
foreach($PC in $DisconnectedComputers){ $Report += "$PC`n"}
$Report.replace("`n", "`r`n") | Out-File $Outfile

Write-Host ""
Write-Host $Report
Write-Host -ForegroundColor Yellow "Report saved to $Outfile"