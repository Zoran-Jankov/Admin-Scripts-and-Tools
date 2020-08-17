function New-FilePermissionGroups {
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Path
    )
    
    begin {
        $FileServerPermissionGroupsOU = 'OU=File Server Permission Groups,DC=uni,DC=net'
    }
    process {
        if ($null -eq (Get-ADGroup -Identity $name)) {
            New-ADOrganizationalUnit -Name $name `
                                     -DisplayName $displayName `
                                     -Path $FileServerPermissionGroupsOU `
                                     -StreetAddress $streetAddress `
                                     -City $city `
                                     -State $state `
                                     -Country $country `
                                     -ProtectedFromAccidentalDeletion $true `
                                     -Description $description `
        }
        
    }
}