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
New-Folder -Path "D:\Folder"

.EXAMPLE
New-Folder "D:\Folder"

.EXAMPLE
$PathList | New-Folder

.NOTES
Version:        1.7
Author:         Zoran Jankov
#>
function New-Folder {
	[CmdletBinding(SupportsShouldProcess = $true)]
	[OutputType([PSCustomObject])]
	param (
		[Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]
		$Path,

		[Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[bool]
		$Cancel = $false
	)

	process {
		if (-not $Cancel) {
			if ((Test-Path $Path) -eq $true) {
				$Message = "Successfully accessed $Path folder"
				$Cancel = $false
			}
			else {
				try {
					New-Item -Path $Path -ItemType 'Directory'
				}
				catch {
					$Message = "Failed to create $Path folder `n" + $_.Exception
					$Cancel = $true
				}

				if ((Test-Path $Path) -eq $true) {
					$Message = "Successfully created $Path folder"
					$Cancel = $false
				}
			}
		}
		else {
			$Message = "Canceled $Path folder creation"
			$Cancel = $false
		}
		Write-Log -Message $Message
		New-Object -TypeName psobject -Property @{
		Cancel = $Cancel
		}
	}
}