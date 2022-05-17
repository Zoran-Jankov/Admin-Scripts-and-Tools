Get-ADComputer -Properties lastLogon -Filter * | ForEach-Object -Process {
    if (-not (Test-Connection -ComputerName $_.Name -Quiet -Count 1)) {
        $LastLogon = [DateTime]::FromFileTimeutc($_.lastLogon)
        Set-ADComputer -Identity $_.Name -Description ("Not on network - Last logon: " + $LastLogon)
        Write-Host ($_.Name + " Not on network " + $LastLogon) -ForegroundColor Red
    }
    Write-Host ($_.Name + " ONLINE") -ForegroundColor Green
}