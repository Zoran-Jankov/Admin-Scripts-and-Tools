$ComputerList = Get-Content -Path ".\ComputerList.txt"

foreach ($Computer in $ComputerList) {
    Write-Host (Resolve-DnsName -Name $Computer).IPAddress -ForegroundColor Green
}