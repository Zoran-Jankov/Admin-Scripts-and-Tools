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
General notes
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
        if ($OlderThen -gt 0) {
            $DatetoDelete = (Get-Date).AddDays(- $OlderThen)
        }
    }

    process {
        [long] $FolderSpaceFreed = 0
        [short] $FilesRemoved = 0
        [short] $FailedRemovals = 0

        $FullPath = Join-Path -Path $FolderPath -ChildPath $FileName
        $FileList = Get-ChildItem -Path $FullPath

        foreach($File in $FileList) {
            $FileSize  = (Get-Item -Path $File.FullName).Length
            $SpaceFreed = Get-FormattedFileSize -Size $FileSize
            if ($OlderThen -gt 0) {
                Get-Item -Path $File.FullName | Where-Object {$_.LastWriteTime -lt $DatetoDelete} | Remove-Item
            }
            else {
                Remove-Item -Path $File.FullName
            }
            
            

            if((Test-Path -Path $File.FullName) -eq $true) {
                $Message = "Failed to delete " + $File.Name + " file"
                $FailedRemovals ++
            }
            else {
                $Message = "Successfully deleted " + $File.Name + " file - removed " + $SpaceFreed
                $FolderSpaceFreed += $FileSize
                $FilesRemoved ++
            }
        }

        $SpaceFree = Get-FormattedFileSize -Size $FolderSpaceFreed

        if($FilesRemoved -eq 0) {
            $Message = "Successfully deleted " + $FilesRemoved + " files in " + $FolderPath + " folder, and " + $SpaceFree + " of space was freed"
        }
        else {
            $Message = "No files for delition were found in " + $FolderPath + " folder"
        }
        Write-Log -Message $Message
        New-Object -TypeName psobject -Property @{
            FolderSpaceFreed =  $FolderSpaceFreed
            FilesRemoved = $FilesRemoved
            FailedRemovals = $FailedRemovals
		}
    }
}