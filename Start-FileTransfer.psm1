<#
.SYNOPSIS
Transfers files from defined list to remote computer.

.DESCRIPTION
Transfers files from the list to destination folder. Log errors and actions while files are transfered.

.PARAMETER FileList
List od file full names fot transfer

.PARAMETER Destination
Full path to file transfer folder

.EXAMPLE
Start-FileTransfer -FileList (Get-ChildItem ".\Source Path") -Destination ".\Destination Path"

.NOTES
Version:        1.3
Author:         Zoran Jankov
#>
function Start-FileTransfer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Object[]]
        $FileList,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
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