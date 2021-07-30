Connect-AzureAD

$AzureDomain = "company.com"
$Country = "Srbija"

$AzureUsers = Get-AzureADUser

foreach ($AzureUser in $AzureUsers) {
    $Username = $AzureUser | Select-Object UserPrincipalName | ForEach-Object {
        ($_.UserPrincipalName).Replace("@$AzureDomain", "")
    }

    $ADuser = Get-ADUser -Identity $Username -Properties Name, Title, Office, Department, MobilePhone, StreetAddress, City, PostalCode

    if ($ADuser.Enabled) {
        $AzureUser | Get-AzureADUser | Set-AzureADUser -JobTitle $ADuser.Title `
            -Department $ADuser.Department `
            -PhysicalDeliveryOfficeName $ADuser.Office `
            -StreetAddress $ADuser.StreetAddress `
            -Mobile $ADuser.MobilePhone `
            -City $ADuser.City `
            -PostalCode $ADuser.PostalCode `
            -Country $Country
    }
}