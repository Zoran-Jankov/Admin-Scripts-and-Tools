$DaysInactive = 60

$Time = (Get-Date).Adddays(-($DaysInactive))

Get-ADComputer -Filter {LastLogonTimeStamp -lt $Time} -Properties Name, OperatingSystem, LastLogonTimeStamp | Select-Object Name, OperatingSystem | Export-Csv ".\Inactive-Computers.csv"