<#
.SYNOPSIS
Transfers files from defined list to remote computer.

.DESCRIPTION
Transfers files from ".\Files Paths.txt" list to remote computer. Log errors while file transfering.

.PARAMETER DestinationPath
Full path to file transfer folder.

.PARAMETER Computer
Name of the remote computer to which files are being transferred.
#>
function Start-FileTransfer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [Object[]]
        $FileList,

        [Parameter(Position = 1, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Destination
    )

    begin {
        Import-Module '.\Write-Log.psm1'
    }

    process {
        $successfulTransfers = 0
        $failedTransfers = 0

	    foreach($file in $FileList) {
		    #File name extraction from file full path
		    $FileName = Split-Path $file -leaf
		
		    try {
			    Copy-Item -Path $file -Destination $Destination -Force
		    }
		    catch {
                $Message = "Failed to transfer " + $FileName + " file to " + $Destination + " folder `n" + $_.Exception
                $OperationResult = 'Fail'
                $failedTransfers ++
            }

            $TransferDestination = Join-Path -Path $Destination -ChildPath $FileName

            if(Test-Path -Path $TransferDestination) {
                $Message = "Successfully transferred " + $FileName + " file to " + $TransferDestination + " folder"
                $OperationResult = 'Success'
                $successfulTransfers ++
            }
            Write-Log -OperationResult $OperationResult -Message $Message
        }
        New-Object -TypeName psobject -Property @{
            Successful = $successfulTransfers
            Failed = $failedTransfers
        }
    }
}