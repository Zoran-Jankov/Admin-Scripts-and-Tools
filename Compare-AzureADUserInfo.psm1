Compare-AzureADUserInfo {
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
        $UserAttributes = @(
        'JobTitle',
        'Department',
        'StreetAddress',
        'City',
        'PostalCode'
        )
    }

    process {
        foreach ($UserAttribute in $UserAttributes) {

            $AzureADUserAttributeValue = $AzureADUSer | Select-Object -Property $UserAttribute
            $UserAttributeValue = $Employee | Select-Object -Property $UserAttribute

            if ($AzureADUserAttributeValue -ne $UserAttributeValue) {
                Write-Host -ForegroundColor Yellow -Object 'Old value:'
                Write-Host -ForegroundColor Yellow -Object $AzureADUserAttributeValue
                Write-Host -ForegroundColor Cyan -Object 'New value:'
                Write-Host -ForegroundColor Cyan -Object $UserAttributeValue
            }
        }
    } 
}