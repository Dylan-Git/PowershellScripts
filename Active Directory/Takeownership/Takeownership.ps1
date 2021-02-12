$folder = Read-Host -Prompt "Folder path"

get-childitem $folder -Recurse -Hidden | %{ takeown /f $_.FullName  /a }
get-childitem $folder -Recurse -Hidden | %{ icacls $_.FullName /grant administrators:F /inheritance:r}

#test  
