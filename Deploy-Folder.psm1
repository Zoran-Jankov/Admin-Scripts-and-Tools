<#
.SYNOPSIS
Creates folder if it does not already exists.

.DESCRIPTION
This function check if defined transfer folder exists and if not it creates it on remote computer.

.PARAMETER Path
Full path of the folder.

.PARAMETER Cancel
If Cancel parameter set to true the folder deployment is canceled. This is used in pipeline when it is important to skip this
operation if last operation failed.

.EXAMPLE
Deploy-Folder -Path 'D:\Folder\Folder'

.EXAMPLE
$PathList | Deploy-Folder
#>
function Deploy-Folder {
	param (
		[Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]
		$Path,

		[Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[boolean]
		$Cancel = $false
	)

	begin {
		Import-Module '.\Write-Log.psm1'
	}

	process {
		if (-not $Cancel) {
			if ((Test-Path $Path) -eq $true) {
				$Message = "Successfully accessed " + $Path + " folder"
				$OperationResult  = 'Success'
			}
			else {
				try {
					New-Item -Path $Path -ItemType "Directory"
				}
				catch {
					$Message = "Failed to create " + $Path + " folder `n" + $_.Exception
					$OperationResult  = 'Fail'
				}

				if ((Test-Path $Path) -eq $true) {
					$Message = "Successfully created " + $Path + " folder"
					$OperationResult  = 'Success'
				}
			}
		}
		else {
			$Message = "Canceled " + $Path + " folder deployment"
			$OperationResult  = 'Success'
		}

		Write-Log -OperationResult $OperationResult -Message $Message

		if ($OperationResult -ne 'Fail') {
			$Cancel = $false
		}
		else {
			$Cancel = $true
		}

		New-Object -TypeName psobject -Property @{
			Cancel = $Cancel
		}
	}
}