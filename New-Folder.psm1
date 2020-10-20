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
Deploy-Folder -Path "D:\Folder\Folder"

.EXAMPLE
$PathList | Deploy-Folder
#>
function New-Folder {
    [CmdletBinding()]
	param (
		[Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]
		$Path,

		[Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[boolean]
		$Cancel = $false
	)

	process {
		if (-not $Cancel) {
			if ((Test-Path $Path) -eq $true) {
				$Message = "Successfully accessed " + $Path + " folder"
				$Cancel = $false
			}
			else {
				try {
					New-Item -Path $Path -ItemType 'Directory'
				}
				catch {
					$Message = "Failed to create " + $Path + " folder `n" + $_.Exception
					$Cancel = $true
				}

				if ((Test-Path $Path) -eq $true) {
					$Message = "Successfully created " + $Path + " folder"
					$Cancel = $false
				}
			}
		}
		else {
			$Message = "Canceled " + $Path + " folder deployment"
			$Cancel = $false
		}

		Write-Log -Message $Message
		
		New-Object -TypeName psobject -Property @{
			Cancel = $Cancel
		}
	}
}