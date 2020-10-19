<#
.SYNOPSIS
Writes a log entry to console, log file and report file.

.DESCRIPTION
Creates a log entry with timestamp and message passed thru a parameter Message or thru pipeline, and saves the log entry to log
file, to report log file, and writes the same entry to console. In Configuration.cfg file paths to report log and permanent log
file are contained, and option to turn on or off whether a report log and permanent log should be written. If Configuration.cfg
file is absent it loads the default values. Depending on the OperationResult parameter, log entry can be written with or without
a timestamp. Format of the timestamp is "yyyy.MM.dd. HH:mm:ss:fff", and this function adds " - " after timestamp and before the
main message.

.PARAMETER OperationResult
Parameter description

.PARAMETER Message
Parameter description

.EXAMPLE
An example

.NOTES
Version:        1.5
Author:         Zoran Jankov
#>
function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Message
    )

    begin {
        if (Test-Path -Path '.\Configuration.cfg') {
            $Configuration = Get-Content '.\Configuration.cfg' | ConvertFrom-StringData
            $LogFile    = $Configuration.LogFile
            $ReportFile = $Configuration.ReportFile
            $WriteLog   = $Configuration.WriteLog -eq "true"
            $SendReport = $Configuration.SendReport -eq "false"
        }
        else {
            $LogFile    = '.\Log.log'
            $ReportFile = '.\Report.log'
            $WriteLog   = $true
            $SendReport = $true
        }

        if (-not (Test-Path -Path $LogFile)) {
            New-Item -Path $LogFile -ItemType File
        }

        if (-not (Test-Path -Path $ReportFile)) {
            New-Item -Path $ReportFile -ItemType File
        }
    }
    
    process {
        $Timestamp = Get-Date -Format "yyyy.MM.dd. HH:mm:ss:fff"
        $LogEntry = $Timestamp + " - " + $Message
        
        Write-Verbose $LogEntry -Verbose
    
        if ($WriteLog) {
            Add-content -Path $LogFile -Value $LogEntry
        }
    
        if ($SendReport) {
            Add-content -Path $ReportFile -Value $LogEntry
        }
    }
}

<#
.SYNOPSIS
Sends a Report.log file to defined email address

.DESCRIPTION
This function sends a report log file as an attachment to defined email address. In configuration hashtable parameter email
settings are defined.

.PARAMETER configuration
A hashtable that contains information about report log file location, mail settings and weather report should be sent at all.

.PARAMETER FinalMessage
Additional variable information to be sent in the mail body.

.EXAMPLE
Send-Report -FinalMessage "Successful script execution"

.NOTES
Version:        1.4
Author:         Zoran Jankov
#>
function Send-Report {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FinalMessage
    )

    begin {
        $Configuration = Get-Content '.\Configuration.cfg' | ConvertFrom-StringData
    }

    process {
        if ($Configuration.SendReport -eq 'true') {
            $Body = $Configuration.Body + "`n" + $FinalMessage
    
            Send-MailMessage -SmtpServer $Configuration.SmtpServer `
                             -Port $Configuration.Port `
                             -To $Configuration.To `
                             -From $Configuration.From `
                             -Subject $Configuration.Subject `
                             -Body $Body `
                             -Attachments $Configuration.ReportFile
    
            Remove-Item -Path $Configuration.ReportFile
        }
    }
}

<#
.SYNOPSIS
Transfers files from defined list to remote computer.

.DESCRIPTION
Transfers files from ".\Files Paths.txt" list to remote computer. Log errors while file transfering.

.PARAMETER DestinationPath
Full path to file transfer folder.

.PARAMETER Computer
Name of the remote computer to which files are being transferred.
#>
function Start-FileTransfer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [Object[]]
        $FileList,

        [Parameter(Position = 1, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Destination
    )

    process {
        $successfulTransfers = 0
        $failedTransfers = 0

	    foreach($file in $FileList) {
		    #File name extraction from file full path
		    $FileName = Split-Path $file -leaf
		
		    try {
			    Copy-Item -Path $file -Destination $Destination -Force
		    }
		    catch {
                $Message = "Failed to transfer " + $FileName + " file to " + $Destination + " folder `n" + $_.Exception
                $failedTransfers ++
            }

            $TransferDestination = Join-Path -Path $Destination -ChildPath $FileName

            if(Test-Path -Path $TransferDestination) {
                $Message = "Successfully transferred " + $FileName + " file to " + $TransferDestination + " folder"
                $successfulTransfers ++
            }
            Write-Log -Message $Message
        }
        New-Object -TypeName psobject -Property @{
            Successful = $successfulTransfers
            Failed = $failedTransfers
        }
    }
}

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

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Size
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-FormattedFileSize {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [long]
        $Size
    )

    If ($Size -gt 1TB) {
        $StringValue = [string]::Format('{0:0.00} TB', $Size / 1TB)
    }
    elseIf ($Size -gt 1GB) {
        $StringValue = [string]::Format('{0:0.00} GB', $Size / 1GB)
    }
    elseIf ($Size -gt 1MB) {
        $StringValue = [string]::Format('{0:0.00} MB', $Size / 1MB)
    }
    elseIf ($Size -gt 1KB) {
        $StringValue = [string]::Format('{0:0.00} kB', $Size / 1KB)
    }
    else {
        $StringValue = [string]::Format('{0:0.00} B', $Size)
    }
    return $StringValue
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER String
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Convert-SerbianToEnglish {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $String
    )
    
    process {
        $String.Replace('č', 'c').
                Replace('ć', 'c').
                Replace('đ', 'dj').
                Replace('š', 's').
                Replace('ž', 'z').
                Replace('Č', 'C').
                Replace('Ć', 'C').
                Replace('Đ', 'Dj').
                Replace('Š', 'S').
                Replace('Ž', 'Z')
    }
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER FullName
Parameter description

.PARAMETER ReverseNamePositions
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-UserNameFromFullName {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FullName,

        [Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [switch]
        $ReverseNamePositions = $false
    )

    begin {
        if ($ReverseNamePositions) {
            $Front = -1
            $End = 0
        }
        else {
            $Front = 0
            $End = -1
        }
    }

    process {
        $UserNameComponents = $FullName.Trim().ToLower().Split(" ")

        $UserName = '{0}.{1}' -f $UserNameComponents[$Front], $UserNameComponents[$End]

        Convert-SerbianToEnglish -String $UserName
    }
}

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
General notes
#>
function New-FilePermissionGroups {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $OUPath,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FolderPath,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [Object[]]
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


function Remove-Files
{
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Path,

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Object[]]
        $FileNames
    )

    process {
        [long] $FolderSpaceFreed = 0;
        [short] $FilesRemoved = 0;
    
        foreach($File in $FileList) {       
            $FileSize  = (Get-Item -Path $File.FullName).Length
            $SpaceFreed = Get-FormattedFileSize -Size $FileSize
            Remove-Item -Path $File.FullName
            $FolderSpaceFreed += $FileSize
            $FilesRemoved ++
            
            if((Test-Path -Path $File.FullName) -eq $true) {
                $Message = "Failed to delete " + $File.Name + " file"
                Write-Log -Message $Message
            }
            else{
                $Message = "Successfully deleted " + $File.Name + " file - removed " + $SpaceFreed
                Write-Log -Message $Message
            }
        }
        New-Object -TypeName psobject -Property @{
            FolderSpaceFreed =  $FolderSpaceFreed
            FilesRemoved = $FilesRemoved
		}
    }
}