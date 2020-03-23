# Script: rolegather.ps1
# Author: Zach Thorne
# Date: 3-17-2020
# Purpose: Gather Puppet Role on each windows server
#
# Steps:
#  1. Get list of hostnames
#  2. Run the following items on each server on list and write to report
#  2a. Test connection
#  2b. Check for puppet service
#  2c. Check the current puppet role

# Calculates the current role in the csr_attributes file
          $roleparse = select-string -Path c:\ProgramData\Puppetlabs\puppet\etc\csr_attributes.yaml -Pattern "pp_role:*"
          $roleparse1 = $roleparse.line
          $seperator = "pp_role:"," "
          $option = [System.StringSplitOptions]::RemoveEmptyEntries
          $currentrole = $roleparse1.split($seperator,$option)

          # Looks for the Puppet Service, if not puppet is not installed
          $puppetinstalledcalc = if (get-service -name puppets -ErrorAction SilentlyContinue) {Write-Output 'Installed'} else {
          Write-Output 'Not Installed'
          }

          # Generates the FQDN of the server which is what the Puppet Agent Certificate is calculated from
          $hostnamecalc = ([System.Net.Dns]::GetHostByName($env:computerName)).hostname

          # Loading Variables
          $puppetcertname = $hostnamecalc
          $puppetinstalled = $puppetinstalledcalc
          $puppet30running = (get-service -name puppet -ErrorAction SilentlyContinue).status
          $puppetstartup = (get-service -name puppet -ErrorAction SilentlyContinue).StartType
          $puppetrole = $currentrole | Out-String -Width 150

          # Creates PowerShell Object for Puppet
          $puppet = New-Object -TypeName PSObject

          # Adds the members of Puppet Object
          $puppet | Add-Member -MemberType NoteProperty -Name PuppetCertname -Value $puppetcertname
          $puppet | Add-Member -MemberType NoteProperty -Name PuppetInstalled -Value $puppetinstalled
          $puppet | Add-Member -MemberType NoteProperty -Name 30minRun -Value $puppet30running
          $puppet | Add-Member -MemberType NoteProperty -Name StartupType -Value $puppetstartup
          $puppet | Add-Member -MemberType NoteProperty -Name CurrentRole -Value $puppetrole -ErrorAction SilentlyContinue
