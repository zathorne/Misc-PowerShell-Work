##Script to check for SMBv1 and output as a external fact
$getOS=Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption
$srv=Get-WindowsFeature FS-SMB1

if ($getOS.Caption -eq "Microsoft Windows Server 2012 R2 Standard")
{

write-output "smbv1=$srv.installed"

}
else
{

Write-Output "smbv1=Not 2012 R2"

}
