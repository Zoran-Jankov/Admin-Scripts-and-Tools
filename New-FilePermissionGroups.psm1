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
        $BaseName = (Split-Path -Path $FolderPath -Leaf).Trim().
                                                         Replace(' ','_').
                                                         Replace('č', 'c').
                                                         Replace('ć', 'c').
                                                         Replace('đ', 'dj').
                                                         Replace('š', 's').
                                                         Replace('ž', 'z').
                                                         ToUpper()
        $GroupPrefixes = @(
            'PG-RW-',
            'PG-RO-'
        )

        foreach ($GroupPrefix in $GroupPrefixes) {
            $Name = $GroupPrefix + $BaseName
            try {
                New-ADOrganizationalUnit -Name $Name `
                                         -DisplayName $Name `
                                         -Path $OUPath `
                                         -StreetAddress $Configuration.StreetAddress `
                                         -City $Configuration.City `
                                         -State $Configuration.State `
                                         -Country $Configuration.Country `
                                         -ProtectedFromAccidentalDeletion $true `
                                         -Description $FolderPath
            }
            catch {
                #TODO Write-Log
            } 
        }
    }
}