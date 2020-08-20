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
        Import-Module '.\Write-Log.psm1'
    }

    process {
        $OldValue = $AzureADUser | Select-Object -Property 'JobTitle'
        $NewValue = $Employee | Select-Object -Property 'JobTitle'
        if ($OldValue.JobTitle -ne $NewValue.JobTitle) {
            $AzureADUser | Set-AzureADUser -JobTitle $NewValue.JobTitle
            $Message = 'JobTitle for user ' + $AzureADUser.UserPrincipalName + ' changed from < ' + $OldValue.JobTitle + ' > to < ' + $NewValue.JobTitle + ' >'
            Write-Log -OperationResult Info -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'Department'
        $NewValue = $Employee | Select-Object -Property 'Department'
        if ($OldValue.Department -ne $NewValue.Department) {
            $AzureADUser | Set-AzureADUser -Department $NewValue.Department
            $Message = 'Department for user ' + $AzureADUser.UserPrincipalName + ' changed from < ' + $OldValue.Department + ' > to < ' + $NewValue.Department + ' >'
            Write-Log -OperationResult Info -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'StreetAddress'
        $NewValue = $Employee | Select-Object -Property 'StreetAddress'
        if ($OldValue.StreetAddress -ne $NewValue.StreetAddress) {
            $AzureADUser | Set-AzureADUser -StreetAddress $NewValue.StreetAddress
            $Message = 'StreetAddress for user ' + $AzureADUser.UserPrincipalName + ' changed from < ' + $OldValue.StreetAddress + ' > to < ' + $NewValue.StreetAddress + ' >'
            Write-Log -OperationResult Info -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'City'
        $NewValue = $Employee | Select-Object -Property 'City'
        if ($OldValue.City -ne $NewValue.City) {
            $AzureADUser | Set-AzureADUser -City $NewValue.City
            $Message = 'City for user ' + $AzureADUser.UserPrincipalName + ' changed from < ' + $OldValue.City + ' > to < ' + $NewValue.City + ' >'
            Write-Log -OperationResult Info -Message $Message
        }

        $OldValue = $AzureADUser | Select-Object -Property 'PostalCode'
        $NewValue = $Employee | Select-Object -Property 'PostalCode'
        if ($OldValue.PostalCode -ne $NewValue.PostalCode) {
            $AzureADUser | Set-AzureADUser -PostalCode $NewValue.PostalCode
            $Message = 'PostalCode for user ' + $AzureADUser.UserPrincipalName + ' changed from < ' + $OldValue.PostalCode + ' > to < ' + $NewValue.PostalCode + ' >'
            Write-Log -OperationResult Info -Message $Message
        }

        $AzureADUser | Set-AzureADUser -Country 'Srbija'
    }
}