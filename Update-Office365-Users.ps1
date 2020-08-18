Import-Module '.\Get-UserNameFromFullName.psm1'
Import-Module '.\Write-Log.psm1'
Import-Module '.\Compare-AzureADUserInfo.psm1'

$Employees = Import-Csv -Path $Path -Delimiter ';'

foreach ($Employee in $Employees) {
    $UserName = Get-UserNameFromFullName -FullName $Employee.FullName
    $UserPrincipalName = $UserName + '@univerexport.rs'
    try {
        $AzureADUser = Get-AzureADUser -ObjectId $UserPrincipalName
    }
    catch {
        $Message = "Faild to get " + $UserPrincipalName + " Azure AD user `n" + $_.Exception
        $OperationResult = 'Fail'
    }

    if ($null -ne $AzureADUser) {
        Compare-AzureADUserInfo -AzureADUser $AzureADUser -Employee $Employee
        do {
            $Confirmation = Read-Host "Update Azure AD user? [y/n]"

            if ($Confirmation -eq 'y') {
            }
            elseif ($Confirmation -eq 'n') {
                $Message = "Canceled " + $UserPrincipalName + " Azure AD User update"
                $OperationResult = 'Fail'
            }
            else {
            
        }
        }
        while(($Confirmation -ne 'y') -or ($Confirmation -ne 'n'))
    }

    Write-Log -OperationResult $OperationResult -Message $Message
}