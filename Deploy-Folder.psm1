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
        [Object[]]
        $Configuration,

		[Parameter(Position = 1, Mandatory = $true)]
		[String]
		$Path
	)

	Import-Module '.\Write-Log.psm1'

    if((Test-Path $Path) -eq $true)
    {
		$message = "Successfully accessed " + $Path + " folder"
		Write-Log -Configuration $Configuration -OperationSuccessful "Successful" -Message $message
		$operationSuccessful = $true
	}
	else
	{
		$message = "Failed to access " + $Path + " folder - MISSING FOLDER ERROR"
		Write-Log -Configuration $Configuration -OperationSuccessful "Failed" -Message $message

		try
		{
			New-Item -Path $Path -ItemType "Directory"
		}
		catch
		{
			Write-Log -Configuration $Configuration -OperationSuccessful "Failed" -LogSeparator $_.Exception
		}

		if((Test-Path $Path) -eq $true)
		{
			$message = "Successfully created " + $Path + " folder"
			Write-Log -Configuration $Configuration -OperationSuccessful "Successful" -Message $message
			$operationSuccessful = $true
		}
		else
		{
			$message = "Failed to create " + $Path + " folder"
			Write-Log -Configuration $Configuration -OperationSuccessful "Failed" -Message $message
			$operationSuccessful = $false
		}
	}
	return $operationSuccessful
}