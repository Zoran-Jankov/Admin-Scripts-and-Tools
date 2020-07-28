<#
.SYNOPSIS
Creates transfer folder if it does not already exists

.DESCRIPTION
This function check if defined transfer folder exists and if not it creates it on remote computer

.PARAMETER Path
Full path of the folder.

.EXAMPLE
Deploy-TransferFolder -Path "\\RemoteComputer\D$\Transfer Folder"
#>
function Deploy-TransferFolder
{
    param([String]$Path)

	$message = "Attempting to access " + $networkDrive + $transferFolder + " folder"
	Write-Log -Message $message

    if((Test-Path $Path) -eq $false)
    {
		$message = "Failed to access " + $networkDrive + $transferFolder + " folder - MISSING FOLDER ERROR"
		Write-Log -Message $message

		$message = "Attempting to create " + $networkDrive + $transferFolder + " folder"
		Write-Log -Message $message

		New-Item -Path $Path -ItemType "Directory"
		if((Test-Path $Path) -eq $true)
		{
			$message = "Successfully created " + $networkDrive + $transferFolder + " folder"
			Write-Log -Message $message
		}
		else
		{
			$message = "Failed to create " + $networkDrive + $transferFolder + " folder"
			Write-Log -Message $message
		}
		
	}
	else
	{
		$message = "Successfully accessed " + $networkDrive + $transferFolder + " folder"
		Write-Log -Message $message
	}
}