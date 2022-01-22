$Computers = Get-ADComputer -Filter * -SearchBase "CN=Computers,DC=company,DC=com"
$LocalAdmins = @()

foreach ($Computer in $Computers) {
    Invoke-Command -ComputerName $Computer.Name -ScriptBlock {
        $Admins = Get-LocalGroupMember -Group 'Administrators' | Where-Object -FilterScript {
            $_.PrincipalSource -eq 'ActiveDirectory'
            } | ForEach-Object -Process {
				n
            $LocalAdmins.Add(($_.Name + " on " + $Computer.Name ))
        }
    }
}

$LocalAdmins | Out-File -FilePath "C:\LocalAdmins.txt"