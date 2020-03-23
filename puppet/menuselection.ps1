$global:i=0
get-service | where {$_.status -eq 'running'} |
Select @{Name="Item";Expression={$global:i++;$global:i}},
Name -OutVariable menu | format-table -AutoSize
$r = Read-Host "Select a service to restart by number"
$svc = $menu | where {$_.item -eq $r}
Write-Host "Restarting $($svc.name)" -ForegroundColor Green
Restart-Service $svc.name -PassThru –force
