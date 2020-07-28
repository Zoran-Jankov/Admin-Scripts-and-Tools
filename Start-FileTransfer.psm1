<#
.SYNOPSIS
Transfers files from '.\Files Paths.txt' list to remote computer.

.DESCRIPTION
Transfers files from '.\Files Paths.txt' list to remote computer. Log errors while file transfering.

.PARAMETER DestinationPath
Full path to file transfer folder.

.PARAMETER Computer
Name of the remote computer to which files are being transferred.
#>
function Start-FileTransfer
{
    [CmdletBinding()]
    param
    (
        [string]
        $DestinationPath, 

        [string]$Computer
    )

	foreach($file in $filesPaths)
	{
		#File name extraction from file full path
		$fileName = Split-Path $file -leaf

		$message = "Attempting to transfer " + $fileName + " file to " + $Computer + " remote computer"
		Write-Log -Message $message
		
		try
		{
			Copy-Item -Path $file -Destination $DestinationPath
			$message = "Successfully transferred " + $fileName + " file to " + $Computer + " remote computer"
			Write-Log -Message $message
		}
		catch
		{
			$message = "Failed to transfer " + $fileName + " file to " + $Computer + " remote computer"
			Write-Log -Message $message
			Write-Log -Message $_.Exception
		}
	}

	$message = "Successfully transferred files to " + $Computer + " remote computer"
	Write-Log -Message $message
}