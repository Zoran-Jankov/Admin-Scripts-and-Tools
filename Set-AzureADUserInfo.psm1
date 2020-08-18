Set-AzureADUserInfo {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Microsoft.Open.AzureAD.Model.DirectoryObject]
        $AzureADUser,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Object[]]
        $Employee
    )

    begin {
        Import-Module '.\Write-Log.psm1'

        $UserAttributes = @('JobTitle',
            'Department',
            'StreetAddress',
            'City','PostalCode'
            )
    }

    process {
        foreach ($UserAttribute in $UserAttributes) {
            $OldValue = $AzureADUser | Select-Object -Property $UserAttributes
            $NewValue = $Employee | Select-Object -Property $UserAttributes
            if ($OldValue -ne $NewValue) {
                $AzureADUser | Set-AzureADUser -JobTitle $NewValue
                $Message = $UserAttribute + " for user " + $AzureADUser + " changed from [" + $OldValue + "] to [" + $NewValue + "]"
                Write-Log -OperationResult Info -Message $Message
            }
        }

        $AzureADUser | Set-AzureADUser -Country 'RS'
    }
}