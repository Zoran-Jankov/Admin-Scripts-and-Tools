<#
.SYNOPSIS
Creates transfer folder if it does not already exists

.DESCRIPTION
This function check if defined transfer folder exists and if not it creates it on remote computer

.PARAMETER Path
Full path of the folder.

.EXAMPLE
Deploy-Folder -Path "\\RemoteComputer\D$\Transfer Folder"
#>
function Deploy-Folder
{
	param
	(
		[Parameter(Position = 0, Mandatory = $true)]
		[String]
		$Path
	)

	Import-Module '.\Write-Log.psm1'

    if((Test-Path $Path) -eq $true)
    {
		$message = "Successfully accessed " + $Path + " folder"
		Write-Log -OperationResult Success -Message $message
		$OperationResult  = $true
	}
	else
	{
		$message = "Failed to access " + $Path + " folder - MISSING FOLDER ERROR"
		Write-Log -OperationResult Fail -Message $message

		try
		{
			New-Item -Path $Path -ItemType "Directory"
		}
		catch
		{
			Write-Log -OperationResult Fail -Message $_.Exception
		}

		if((Test-Path $Path) -eq $true)
		{
			$message = "Successfully created " + $Path + " folder"
			Write-Log -OperationResult Success-Message $message
			$OperationResult  = $true
		}
		else
		{
			$message = "Failed to create " + $Path + " folder"
			Write-Log -OperationResult Fail -Message $message
			$OperationResult  = $false
		}
	}
	return $OperationResult 
}