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
Version:        1.5
Author:         Zoran Jankov
#>
function Start-FileTransfer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSCustomObject])]
    param (

        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "List od file full names fot transfer")]
        [System.Object[]]
        $FileList,

        [Parameter(Mandatory = $true,
                   Position = 1,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "Full path to file transfer folder")]
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
                Write-Log -Message ("Failed to transfer $FileName file to $Destination folder `n" + $_.Exception)
                $FailedTransfers ++
                continue
            }

            $TransferDestination = Join-Path -Path $Destination -ChildPath $FileName

            if(Test-Path -Path $TransferDestination) {
                Write-Log -Message "Successfully transferred $FileName file to $Destination folder"
                $SuccessfulTransfers ++
            }
        }
        New-Object -TypeName psobject -Property @{
            Successful = $SuccessfulTransfers
            Failed = $FailedTransfers
        }
    }
}