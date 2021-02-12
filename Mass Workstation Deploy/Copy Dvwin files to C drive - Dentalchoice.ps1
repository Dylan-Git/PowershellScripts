mkdir c:\dvwin
Get-ChildItem -path "\\dc-dcw-vapp01.dc.local\dvwin\dvwin\pbdk\" -Recurse | Copy-Item -Destination C:\dvwin