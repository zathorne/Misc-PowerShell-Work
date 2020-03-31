# Script: query_insecure_ldap_connections.ps1
# Date: 3-31-2020
# Purpose: Outputs events to CSV to assist in identifying apps using insecure LDAP connections
# Related information: https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/ldap-channel-binding-and-ldap-signing-requirements-march-2020/ba-p/921536
# Start of Script
# Prepare Variables
Param (
        [parameter(Mandatory=$false,Position=0)][String]$ComputerName = "localhost",
        [parameter(Mandatory=$false,Position=1)][Int]$Hours = 24)

# Create an Array to hold our returnedvValues
$InsecureLDAPBinds = @()

# Grab the appropriate event entries
$Events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{Logname='Directory Service';Id=2889; StartTime=(get-date).AddHours("-$Hours")}

# Loop through each event and output the 
ForEach ($Event in $Events) { 
	$eventXML = [xml]$Event.ToXml()
	
	# Build Our Values
	$Client = ($eventXML.event.EventData.Data[0])
	$IPAddress = $Client.SubString(0,$Client.LastIndexOf(":")) #Accomodates for IPV6 Addresses
	$Port = $Client.SubString($Client.LastIndexOf(":")+1) #Accomodates for IPV6 Addresses
	$User = $eventXML.event.EventData.Data[1]
	Switch ($eventXML.event.EventData.Data[2])
		{
		0 {$BindType = "Unsigned"}
		1 {$BindType = "Simple"}
		}
	
	# Add Them To a Row in our Array
	$Row = "" | select IPAddress,Port,User,BindType
	$Row.IPAddress = $IPAddress
	$Row.Port = $Port
	$Row.User = $User
	$Row.BindType = $BindType
	
	# Add the row to our Array
	$InsecureLDAPBinds += $Row
}
# Dump it all out to a CSV.
Write-Host $InsecureLDAPBinds.Count "records saved to .\InsecureLDAPBinds.csv for Domain Controller" $ComputerName
$InsecureLDAPBinds | Export-CSV -NoTypeInformation .\InsecureLDAPBinds.csv
# -----------------------------------------------------------------------------
# End of Main Script
