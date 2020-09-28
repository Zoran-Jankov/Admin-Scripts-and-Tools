function Compare-AzureADUserInfo {
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

        $Changes = $false
    }

    process {
        foreach ($UserAttribute in $UserAttributes) {

            $AzureADUserAttributeValue = $AzureADUser | Select-Object -Property $UserAttribute
            $UserAttributeValue = $Employee | Select-Object -Property $UserAttribute

            if ($AzureADUserAttributeValue.$UserAttribute -ne $UserAttributeValue.$UserAttribute) {
                Write-Host -ForegroundColor Green -Object $UserAttribute
                Write-Host -ForegroundColor Yellow -Object ("Old value: " + $AzureADUserAttributeValue.$UserAttribute)
                Write-Host -ForegroundColor Cyan -Object ("New value: " + $UserAttributeValue.$UserAttribute + "`n")
                $Changes = $true
            }
        }
    }
    
    end {
        return $Changes
    }
}