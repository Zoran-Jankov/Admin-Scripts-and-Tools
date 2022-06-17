Get-ADUser -Filter * -SearchBase "OU=Vega Employees,DC=vega,DC=local" | Set-ADUser -PasswordNeverExpires $false -CannotChangePassword $false
