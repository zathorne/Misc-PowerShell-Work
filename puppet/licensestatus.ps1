$var=Get-CimInstance -ClassName SoftwareLicensingProduct | where-object PartialProductKey | select-object LicenseStatus

switch -Regex ("$var") {
    0 {$status = "Unlicensed"}
    1 {$status = "Licensed"}
    2 {$status = "Out-Of-Box Grace Period"}
    3 {$status = "Out-Of-Tolerance Grace Period"}
    4 {$status = "Non-Genuine Grace Period"}
    5 {$status = "Notification"}
    6 {$status = "Extended Grace"}
    default {$status = "Unknown value"}
}

write-output "windows_license_status=${status}"
