<#
.SYNOPSIS
Transfers files from defined list to remote computer.

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
        [Parameter(Position = 0, Mandatory = $true)]
        [Object[]]
        $Configuration,

        [Parameter(Position = 1, Mandatory = $true)]
        [string]
        $Destination
    )

    Import-Module '.\Write-Log.psm1'

    $successfulTransfers = 0
    $failedTransfers = 0

    $fileList = Get-Content -Path $Configuration.FileList

	foreach($file in $fileList)
	{
		#File name extraction from file full path
		$fileName = Split-Path $file -leaf
		
		try
		{
			Copy-Item -Path $file -Destination $Destination -Force
		}
		catch
		{
			Write-Log -Configuration $Configuration -OperationSuccessful "Failed" -LogSeparator $_.Exception
        }

        $transferDestination = Join-Path -Path $Destination -ChildPath $file

        if(Test-Path -Path $transferDestination)
        {
            $message = "Successfully transferred " + $fileName + " file to " + $transferDestination + " folder"
            Write-Log -Configuration $Configuration -OperationSuccessful "Successful" -Message $message
            $successfulTransfers ++
        }
        else
        {
            $message = "Failed to transfer " + $fileName + " file to " + $Destination + " folder"
            Write-Log -Configuration $Configuration -OperationSuccessful "Failed" -Message $message
            $failedTransfers ++
        }
    }

    if($successfulTransfers -gt 0)
    {
        $message = "Successfully transferred " + $successfulTransfers + " files to " + $Destination + " folder"
        Write-Log -Configuration $Configuration -OperationSuccessful "Successful" -Message $message
    }

    if($failedTransfers -gt 0)
    {
        $message = "Failed to transfer " + $failedTransfers + " files to " + $Destination + " folder"
        Write-Log -Configuration $Configuration -OperationSuccessful "Failed" -Message $message
    }

    if(($successfulTransfers -gt 0 ) -and ($failedTransfers -eq 0))
    {
        $message = "Successfully transferred all files to " + $Destination + " folder"
        Write-Log -Configuration $Configuration -OperationSuccessful "Successful" -Message $message
    }
    elseif(($successfulTransfers -gt 0 ) -and ($failedTransfers -gt 0))
    {
        $message = "Successfully transferred some files to " + $Destination + " folder with some failed"
        Write-Log -Configuration $Configuration -OperationSuccessful "Partial" -Message $message
    }
    elseif(($successfulTransfers -eq 0 ) -and ($failedTransfers -gt 0))
    {
        $message = "Failed to transfer any file to " + $Destination + " folder"
        Write-Log -Configuration $Configuration -OperationSuccessful "Failed" -Message $message
    }
}