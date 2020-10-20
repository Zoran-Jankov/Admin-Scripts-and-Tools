<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER AzureADUser
Parameter description

.PARAMETER Employee
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
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
                Write-Verbose -Message $UserAttribute -Verbose
                Write-Verbose -Message ("Old value: " + $AzureADUserAttributeValue.$UserAttribute) -Verbose
                Write-Verbose -Message ("New value: " + $UserAttributeValue.$UserAttribute + "`n") -Verbose
                $Changes = $true
            }
        }
    }
    
    end {
        return $Changes
    }
}