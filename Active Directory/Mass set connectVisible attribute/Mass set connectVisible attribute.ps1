while($true){
    $User = read-host -Prompt "group"
    
    If($User -eq "stop"){break}
    
    Get-ADGroup -Filter {name -like $User} | Set-ADGroup -Replace @{connectVisible=$true}
    Get-ADGroup -Filter {name -like $User} -Properties name,connectVisible | select name,connectVisible
}

