$ComputerList = Get-Content -Path ".\ComputerList.txt"

foreach ($Computer in $ComputerList) {
    if (Test-Connection -ComputerName $Computer -Quiet -Count 1) {
        Write-Host $Computer -ForegroundColor Green
    }
    else {
        Write-Host $Computer -ForegroundColor Red
    }
}