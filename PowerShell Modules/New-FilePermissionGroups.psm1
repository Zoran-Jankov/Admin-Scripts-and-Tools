<#
.SYNOPSIS
Creates file permissions AD groups for a shared folder

.DESCRIPTION
Creates file permissions Read Only and Read-Write AD groups for a shared folder, and grants them appropriate access to the shared folder.

.PARAMETER OUPath
Organization unit path for the permission groups

.PARAMETER FolderPath
Full path of the shared folder

.PARAMETER Credential
Domanin credential for creation of an Active Directory group

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
                   Position = 2,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "Credential for creation of an Active Directory group")]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    process {
        $Result = ""

        if (-not (Test-Path -Path $FolderPath)) {
            $Message = "ERROR - $FolderPath folder does not exists"
            Write-Log -Message $Message
            $Result += "$Message`r`n"
            Write-Output -InputObject $Result
            break
        }
        if (-not ([adsi]::Exists("LDAP://$OUPath"))) {
            $Message = "ERROR - $OUPath organizational unit does not exists"
            Write-Log -Message $Message
            $Result += "$Message`r`n"
            Write-Output -InputObject $Result
            break
        }
        $BaseName = (Split-Path -Path $FolderPath -Leaf).Trim() | Convert-SerbianToEnglish
        $BaseName.ToUpper()
        $Groups = @(
            @{
                Access = "ReadAndExecute"
                Prefix = "PG-RO-"
            }
            @{
                Access = "Modify"
                Prefix = "PG-RW-"
            }
        )
        foreach ($Group in $Groups) {
            $Name = $Group.Prefix + $BaseName
            try {
                New-ADGroup -Name $Name `
                            -DisplayName $Name `
                            -Path $OUPath `
							-GroupCategory Security `
							-GroupScope Global `
                            -Description $FolderPath `
                            -Credential $Credential
            }
            catch {
                $Message = "Failed to create $Name AD group `r`n" + $_.Exception
                Write-Log -Message $Message
                $Result += "$Message`r`n"
                Write-Output -InputObject $Result
                break
            }
            $Message = "Successfully created $Name AD group"
            Write-Log -Message $Message
            $Result += "$Message`r`n"
            $ACL = Get-ACL -Path $FolderPath
            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Name, $Group.Access, "ContainerInherit, ObjectInherit", "None", "Allow")
            $ACL.SetAccessRule($AccessRule)
            try {
                $ACL | Set-Acl -Path $FolderPath
            }
            catch {
                $Message = "Failed to grant " + $Group.Access + " access to $Name ADGroup to $FolderPath `r`n" + $_.Exception
                Write-Log -Message $Message
                $Result += "$Message`r`n"
                continue
            }
            $Message = "Successfully granted " + $Group.Access + " access to $Name ADGroup to $FolderPath shared folder"
            Write-Log -Message $Message
            $Result += "$Message`r`n"
        }
        Write-Output -InputObject $Result
    }
}