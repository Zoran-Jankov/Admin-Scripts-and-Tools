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
        $FileList,

        [Parameter(Position = 1, Mandatory = $true)]
        [string]
        $Destination
    )

    Import-Module '.\Write-Log.psm1'

    $successfulTransfers = 0
    $failedTransfers = 0

	foreach($file in $FileList)
	{
		#File name extraction from file full path
		$fileName = Split-Path $file -leaf
		
		try
		{
			Copy-Item -Path $file -Destination $Destination -Force
		}
		catch
		{
			Write-Log -OperationResult Fail -Message $_.Exception
        }

        $transferDestination = Join-Path -Path $Destination -ChildPath $fileName

        if(Test-Path -Path $transferDestination)
        {
            $message = "Successfully transferred " + $fileName + " file to " + $transferDestination + " folder"
            Write-Log -OperationResult Success -Message $message
            $successfulTransfers ++
        }
        else
        {
            $message = "Failed to transfer " + $fileName + " file to " + $Destination + " folder"
            Write-Log -OperationResult Fail -Message $message
            $failedTransfers ++
        }
    }

    $Transfers = @{Successful = $successfulTransfers; Failed = $failedTransfers}

    return $Transfers
}