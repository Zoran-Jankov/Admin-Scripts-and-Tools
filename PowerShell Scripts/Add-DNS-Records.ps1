$Records = Import-Csv -Path "$PSScriptRoot\Records.csv" -Delimiter ';'
foreach($Record in $Records) {
    Add-DnsServerResourceRecordA -ComputerName "dns.company.local" `
                                 -Name $Record.Name `
                                 -ZoneName "company.local" `
                                 -IPv4Address $Record.IPv4Address `
                                 -CreatePtr `
                                 -Confirm:$false
}