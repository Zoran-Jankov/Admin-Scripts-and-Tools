Compare-AzureADUserInfo {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Object[]]
        $User
    )

    $AzureADUSer = Get-AzureADUser -ObjectId $User.Email

    $UserAttributes = @(
        'JobTitle',
        'Department',
        'StreetAddress',
        'City',
        'PostalCode',
        'Country'
    )

    foreach ($UserAttribute in $UserAttributes) {

        $AzureADUserAttributeValue = $AzureADUSer | Select-Object -Property $UserAttribute
        $UserAttributeValue = $User | Select-Object -Property $UserAttribute

        if ($AzureADUserAttributeValue -ne $UserAttributeValue) {
            Write-Host -ForegroundColor Yellow -Object 'Old value:'
            Write-Host -ForegroundColor Yellow -Object $AzureADUserAttributeValue
            Write-Host -ForegroundColor Cyan -Object 'New value:'
            Write-Host -ForegroundColor Cyan -Object $UserAttributeValue
        }
    }
}