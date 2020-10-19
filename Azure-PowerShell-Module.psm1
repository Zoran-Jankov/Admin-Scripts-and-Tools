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
function Set-AzureADUserInfo {
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
        Import-Module '.\Common-PowerShell-Molule.psm1'
    }

    process {
        $OldValue = $AzureADUser | Select-Object -Property 'JobTitle'
        $NewValue = $Employee | Select-Object -Property 'JobTitle'
        if ($OldValue.JobTitle -ne $NewValue.JobTitle) {
            $AzureADUser | Set-AzureADUser -JobTitle $NewValue.JobTitle
            $Message = "JobTitle for user " + $AzureADUser.UserPrincipalName + " changed from < " + $OldValue.JobTitle + " > to < " + $NewValue.JobTitle + " >"
            Write-Log -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'Department'
        $NewValue = $Employee | Select-Object -Property 'Department'
        if ($OldValue.Department -ne $NewValue.Department) {
            $AzureADUser | Set-AzureADUser -Department $NewValue.Department
            $Message = "Department for user " + $AzureADUser.UserPrincipalName + " changed from < " + $OldValue.Department + " > to < " + $NewValue.Department + " >"
            Write-Log -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'StreetAddress'
        $NewValue = $Employee | Select-Object -Property 'StreetAddress'
        if ($OldValue.StreetAddress -ne $NewValue.StreetAddress) {
            $AzureADUser | Set-AzureADUser -StreetAddress $NewValue.StreetAddress
            $Message = "StreetAddress for user " + $AzureADUser.UserPrincipalName + " changed from < " + $OldValue.StreetAddress + " > to < " + $NewValue.StreetAddress + " >"
            Write-Log -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'City'
        $NewValue = $Employee | Select-Object -Property 'City'
        if ($OldValue.City -ne $NewValue.City) {
            $AzureADUser | Set-AzureADUser -City $NewValue.City
            $Message = "City for user " + $AzureADUser.UserPrincipalName + " changed from < " + $OldValue.City + " > to < " + $NewValue.City + " >"
            Write-Log -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'PostalCode'
        $NewValue = $Employee | Select-Object -Property 'PostalCode'
        if ($OldValue.PostalCode -ne $NewValue.PostalCode) {
            $AzureADUser | Set-AzureADUser -PostalCode $NewValue.PostalCode
            $Message = "PostalCode for user " + $AzureADUser.UserPrincipalName + " changed from < " + $OldValue.PostalCode + " > to < " + $NewValue.PostalCode + " >"
            Write-Log -Message $Message
        }

        $AzureADUser | Set-AzureADUser -Country 'Srbija'
    }
}