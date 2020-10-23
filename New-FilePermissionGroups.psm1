<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER OUPath
Parameter description

.PARAMETER FolderPath
Parameter description

.PARAMETER Configuration
Parameter description

.EXAMPLE
An example

.NOTES
Version:        1.1
Author:         Zoran Jankov
#>
function New-FilePermissionGroups {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $OUPath,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FolderPath,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [System.Object[]]
        $Configuration = "NOT DEFINED"
    )

    begin {
        if ($Configuration -eq "NOT DEFINED") {
            $Configuration = Get-Content -Path "Configuration.cfg"
        }
    }

    process {
        $BaseName = (Split-Path -Path $FolderPath -Leaf).Trim() | Convert-SerbianToEnglish
        $BaseName.ToUpper()

        $GroupPrefixes = @(
            "PG-RW-",
            "PG-RO-"
        )

        foreach ($GroupPrefix in $GroupPrefixes) {
            $Name = $GroupPrefix + $BaseName
            try {
                New-ADGroup -Name $Name `
                            -DisplayName $Name `
                            -Path $OUPath `
							-GroupCategory Security `
							-GroupScope Global `
                            -Description $FolderPath
                $Message = "Successfully created " + $Name + " AD group"
            }
            catch {
                $Message = "Failed to create " + $Name + " AD group `n" + $_.Exception
            }
            Write-Log -Message $Message
        }
    }
}