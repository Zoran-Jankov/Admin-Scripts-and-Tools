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

    process {
        $SuccessfulTransfers = 0
        $FailedTransfers = 0

	    foreach($File in $FileList) {
		    #File name extraction from file full path
		    $FileName = Split-Path $File -leaf

		    try {
			    Copy-Item -Path $File -Destination $Destination -Force
		    }
		    catch {
                $Message = "Failed to transfer " + $FileName + " file to " + $Destination + " folder `n" + $_.Exception
                $FailedTransfers ++
            }

            $TransferDestination = Join-Path -Path $Destination -ChildPath $FileName

            if(Test-Path -Path $TransferDestination) {
                $Message = "Successfully transferred " + $FileName + " file to " + $TransferDestination + " folder"
                $SuccessfulTransfers ++
            }
            Write-Log -Message $Message
        }
        New-Object -TypeName psobject -Property @{
            Successful = $SuccessfulTransfers
            Failed = $FailedTransfers
        }
    }
}