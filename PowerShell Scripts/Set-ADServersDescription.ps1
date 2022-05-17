Get-ADComputer -Filter * -SearchBase "OU=Servers,DC=company,DC=com" | ForEach-Object -Process {
    if (Test-Connection -Quiet -Count 1 -ComputerName $_.Name) {
        try {
            $ComputerSystem = Get-CimInstance -ClassName CIM_ComputerSystem -ComputerName $_.Name
            $Processor = Get-CimInstance -ClassName CIM_Processor -ComputerName $_.Name
        }
        catch {
            continue
        }
        if ($Processor.Name.Count -eq 1) {
            $CPU = $Processor.Name
        }
        else {
            $CPU = $Processor[0].Name + " x " + ($Processor.Name.Count).ToString()
        }
        $RAM = [math]::Round($ComputerSystem.TotalPhysicalMemory / 1GB).ToString() + " GB"
        $Description = $ComputerSystem.Manufacturer + " " `
            + $ComputerSystem.Model + " | " `
            + $CPU `
            + " | RAM " + $RAM
        $Description = $ComputerSystem.Manufacturer + " " `
            + $ComputerSystem.Model + " | " `
            + $CPU `
            + " | RAM " + $RAM
        Set-ADComputer -Identity $_ -Description $Description
    }
}
