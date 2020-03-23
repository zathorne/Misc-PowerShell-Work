# Script: rolegather.ps1
# Author: Zach Thorne
# Date 3-17-2020
# Purpose: Gather all computer objects in the server OU and export name, hostname, and IP to CSV.
Get-ADComputer -Filter * -SearchBase "OU=Servers, DC=DOM1, DC=domain, DC=com" -Properties name, 
ipv4address | select-object Name, dnshostname, ipv4address | export-csv -path c:\scripts\dom1output.csv -encoding utf8
