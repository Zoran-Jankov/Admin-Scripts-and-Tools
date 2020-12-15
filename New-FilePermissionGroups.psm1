<#
.SYNOPSIS
Creates file premitins AD groups for a shared folder

.DESCRIPTION
Long description

.PARAMETER OUPath
Organization unit path for the permission groups

.PARAMETER FolderPath
Full path of the shared folder

.PARAMETER Settings
Script settings

.EXAMPLE
New-FilePermissionGroups -OUPath "OU=File Server Permission Groups,DC=company,DC=com" -FolderPath "\\SERVER\Shared_Folder"

.NOTES
Version:        1.3
Author:         Zoran Jankov
#>
function New-FilePermissionGroups {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValueFromPipeline = $false,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "Organization unit path for the permission groups")]
        [string]
        $OUPath,

        [Parameter(Mandatory = $true,
                   Position = 1,
                   ValueFromPipeline = $false,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "Full path of the shared folder")]
        [string]
        $FolderPath,

        [Parameter(Mandatory = $true,
                   Position = 1,
                   ValueFromPipeline = $false,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "Script settings")]
        [System.Object[]]
        $Settings
    )

    process {
        $BaseName = (Split-Path -Path $FolderPath -Leaf).Trim() | Convert-SerbianToEnglish
        $BaseName.ToUpper()

        $GroupPrefixes = @(
            $Settings.ReadOnly
            $Settings.ReadWrite
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
                $Message = "Successfully created $Name AD group"
            }
            catch {
                $Message = "Failed to create $Name AD group `n" + $_.Exception
            }
            Write-Log -Message $Message
        }
    }
}