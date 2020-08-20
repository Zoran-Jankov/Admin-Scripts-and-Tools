function New-FilePermissionGroups {
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $OUPath,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FolderPath,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [Object[]]
        $Configuration = 'NOT DEFINED'
    )
    
    begin {
        if ($Configuration -eq 'NOT DEFINED') {
            $Configuration = Get-Content -Path 'Configuration.cfg'
        }
    }

    process {
        $Name = 'PG-RW-' + (Split-Path -Path $Path -Leaf).ToUpper().Replace(' ','_')
        try {
            New-ADOrganizationalUnit -Name $Name `
                                     -DisplayName $Name `
                                     -Path $OUPath `
                                     -StreetAddress $Configuration.StreetAddress `
                                     -City $Configuration.City `
                                     -State $Configuration.State `
                                     -Country $Configuration.Country `
                                     -ProtectedFromAccidentalDeletion $true `
                                     -Description $Path
        }
        catch {
            
        } 
    }
}