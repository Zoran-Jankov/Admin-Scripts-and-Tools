$Credential = Get-Credential
$ComputerList = Get-Content -Path ".\ComputerList.txt"

$Data = @()

foreach ($Computer in $ComputerList) {
    if (Test-Connection $Computer -Quiet -Count 1) {
        $ComputerData = New-Object PSObject -Property @{
            Name = $Computer
            IPAddress = (Resolve-DnsName -Name $Computer).IPAddress
            
            Serial = (Get-WmiObject -Class Win32_BIOS -ComputerName $Computer -Credential $Credential).Serialnumber
        }
        $Data += $ComputerData
    }
}

$Data | Export-Csv -Path ".\Computer Serial Numbers.csv"