$names = Import-Csv C:\names.csv

$names | % {

    $Name = ($_.name).trim()
    Add-ADGroupMember -Identity "SP 365 Biz Premium" -Members (Get-ADUser -filter {name -eq $Name}) -Verbose

}