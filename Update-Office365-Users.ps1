Import-Module ".\Write-Log.psm1"
Import-Module ".\Compare-AzureADUserInfo.psm1"
Import-Module ".\Set-AzureADUserInfo.psm1"

$Path = ".\Office365.csv"

$Employees = Import-Csv -Path $Path -Delimiter ";" -Encoding utf8

Connect-AzureAD

foreach ($Employee in $Employees) {
    $UserPrincipalName = $Employee.UserName + "@univerexport.rs"
    try {
        $AzureADUser = Get-AzureADUser -ObjectId $UserPrincipalName
    }
    catch {
        $Message = "Failed to get " + $UserPrincipalName + " Azure AD user `n" + $_.Exception
        $OperationResult = "Fail"
    }

    if ($null -ne $AzureADUser) {
        if (Compare-AzureADUserInfo -AzureADUser $AzureADUser -Employee $Employee) {
            do {
                $Confirmation = Read-Host "Update  " + $UserPrincipalName + " Azure AD user? [y/n]"
    
                if ($Confirmation -eq "y") {
                    Set-AzureADUserInfo -AzureADUser $AzureADUser -Employee $Employee
                    $Message = "Successfully updated " + $UserPrincipalName + " Azure AD User"
                    $OperationResult = "Success"
                }
                elseif ($Confirmation -eq "n") {
                    $Message = "Canceled " + $UserPrincipalName + " Azure AD User update"
                    $OperationResult = "Fail"
                }
            }
            while(($Confirmation -ne "y") -and ($Confirmation -ne "n"))
            Write-Log -OperationResult $OperationResult -Message $Message
        }
    }
}
Write-Log -OperationResult Info -Message "Finished updating Azure AD user information"