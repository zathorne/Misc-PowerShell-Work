# Script: get-groupmembership.ps1
# Author: Zach Thorne
# Date: 1/20/2020
# Purpose: Gather the group membership then output to CSV
Get-ADGroupMember -identity "<groupname>" -Recursive | get-aduser -property DisplayName | select-object name,displayname | out-file c:\temp\groupa.txt
