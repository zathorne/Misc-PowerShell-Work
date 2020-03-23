Get-ADComputer -Filter * -SearchBase "OU=Servers, DC=DOM1, DC=domain, DC=com" -Properties name, i
pv4address | select-object Name, dnshostname, ipv4address | export-csv -path c:\scripts\dom1output.csv -encoding utf8
