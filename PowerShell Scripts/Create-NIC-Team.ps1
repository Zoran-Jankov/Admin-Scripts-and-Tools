$EthernetAdapters = @("NIC1", "NIC2", "NIC3", "NIC4")
$NICTeamName = "NIC Team"

$IPAddress = "192.168.50.100"
$SubnetMask = "24"
$DefaultGateway = "192.168.50.1"
$DNSServer = @("192.168.10.11", "192.168.10.12", "192.168.10.13", "192.168.10.14", "192.168.10.15")

New-NetLbfoTeam -Name $NICTeamName -TeamMembers $EthernetAdapters -LoadBalancingAlgorithm Dynamic -TeamingMode SwitchIndependent
$NICTeam = Get-NetAdapter -Name $NICTeamName
$NICTeam | New-NetIPAddress -IPAddress $IPAddress -PrefixLength $SubnetMask -DefaultGateway
$NICTeam | Set-DnsClientServerAddress 
