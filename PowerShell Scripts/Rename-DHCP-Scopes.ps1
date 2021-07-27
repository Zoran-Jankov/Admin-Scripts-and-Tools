$Scopes = Import-Csv -Path "$PSScriptRoot\DHCP-Scopes.csv"

foreach($Scope in $Scopes) {
    Set-DhcpServerv4Scope -ScopeId $Scope.ScopeId `
                          -Name $Scope.Name `
                          -Description $Scope.Description
}