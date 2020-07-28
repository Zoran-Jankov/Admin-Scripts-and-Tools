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
    param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $Configuration,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $Destination
    )

    Import-Module '.\Write-Log.psm1'

    $fileList = Get-Content -Path $Configuration.FileListPath

	foreach($file in $fileList)
	{
		#File name extraction from file full path
		$fileName = Split-Path $file -leaf
		
		try
		{
			Copy-Item -Path $file -Destination $Destination
		}
		catch
		{
			Write-Log -OperationSuccessful "Failed" -LogSeparator $_.Exception
        }

        if(Get-Item -Path )
        $message = "Successfully transferred " + $fileName + " file to " + $Destination
        Write-Log -Message $message
            
        $message = "Failed to transfer " + $fileName + " file to " + $Destination
		Write-Log -Message $message
	}

	$message = "Successfully transferred files to " + $Computer + " remote computer"
	Write-Log -Message $message
}