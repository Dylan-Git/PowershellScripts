$Clipboard = Get-Clipboard

Select-String -InputObject $Clipboard -Pattern '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b' | % {$_.Matches.Value}
