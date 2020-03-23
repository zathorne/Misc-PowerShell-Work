# Script: gponotlinked.ps1
# Author: Zach Thorne
# Date: 6/20/2019
# Purpose:Create report for Group Policy Objects not linked
Get-GPO -All | Sort-Object displayname | Where-Object { If ( $_ | Get-GPOReport -ReportType XML | Select-String -NotMatch "<LinksTo>" ) 
{$_.DisplayName } } |Select-Object -Property DisplayName,DomainName,Owner,ID,GPOStatus,Description,CreationTime,ModificationTime,UserVersion,ComputerVersion 
| out-file c:\gporeports\UnlinkedGPOs.txt
