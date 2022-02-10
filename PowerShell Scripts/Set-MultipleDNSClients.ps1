$ComputerList = Get-Content -Path ".\ComputerList.txt"
$DNSServersAddresses = ("10.0.0.1", "10.0.0.2")

foreach ($Computer in $ComputerList) {
    Invoke-Command -ComputerName $Computer -ScriptBlock {
        Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $DNSServersAddresses
    }
}
