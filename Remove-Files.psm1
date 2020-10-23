<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Path
Parameter description

.PARAMETER FileNames
Parameter description

.EXAMPLE
An example

.NOTES
Version:        1.3
Author:         Zoran Jankov
#>
function Remove-Files {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FolderPath,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FileName,

        [Parameter(Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int]
        $OlderThen = 0
    )

    begin {
        $DateToDelete = (Get-Date).AddDays(- $OlderThen)
    }

    process {
        $FolderSpaceFreed = 0
        $FilesRemoved = 0
        $FailedRemovals = 0

        $FullPath = Join-Path -Path $FolderPath -ChildPath $FileName
        $FileList = Get-ChildItem -Path $FullPath | Where-Object {$_.LastWriteTime -lt $DateToDelete}

        foreach ($File in $FileList) {
            $FileSize  = (Get-Item -Path $File.FullName).Length
            $SpaceFreed = Get-FormattedFileSize -Size $FileSize

            Get-Item -Path $File.FullName | Remove-Item

            if ((Test-Path -Path $File.FullName) -eq $true) {
                $Message = "Failed to delete " + $File.Name + " file"
                $FailedRemovals ++
            }
            else {
                $Message = "Successfully deleted " + $File.Name + " file - removed " + $SpaceFreed
                $FolderSpaceFreed += $FileSize
                $FilesRemoved ++
            }
            Write-Log -Message $Message
        }

        $SpaceFreed = Get-FormattedFileSize -Size $FolderSpaceFreed

        if ($FilesRemoved -gt 0) {
            $Message = "Successfully deleted " + $FilesRemoved + " files in " + $FolderPath + " folder, and " + $SpaceFreed + " of space was freed"
            Write-Log -Message $Message
        }
        if ($FailedRemovals -gt 0) {
            $Message = "Failed to delete " + $FailedRemovals + " files in " + $FolderPath + " folder"
            Write-Log -Message $Message
        }
        if ($FilesRemoved -eq 0 -and $FailedRemovals -eq 0) {
            $Message = "No files for delition were found in " + $FolderPath + " folder"
            Write-Log -Message $Message
        }
        
        New-Object -TypeName psobject -Property @{
            FolderSpaceFreed =  $FolderSpaceFreed
            FilesRemoved = $FilesRemoved
            FailedRemovals = $FailedRemovals
		}
    }
}