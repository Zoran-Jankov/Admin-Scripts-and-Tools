$ComputerList = Get-Content -Path ".\ComputerList.txt"

foreach ($Computer in $ComputerList) {
    $ComputerSystem = Get-WmiObject Win32_ComputerSystem -ComputerName $Computer
    Write-Host $ComputerSystem.Name -ForegroundColor Green
}