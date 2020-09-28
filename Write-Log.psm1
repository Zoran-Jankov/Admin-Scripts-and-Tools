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
    param (
        [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateSet('Success', 'Fail', 'Partial', 'Info', 'None')]
        [String]
        $OperationResult = 'None',

        [Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]
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

        switch ($OperationResult) {
            "Success" {
                $ForegroundColor = "Green"
                break
            }
    
            "Fail" {
                $ForegroundColor = "Red"
                break
            }
    
            "Partial" {
                $ForegroundColor = "Yellow"
                break
            }
    
            "Info" {
                $ForegroundColor = "Cyan"
                break
            }
    
            "None" {
                $ForegroundColor = "White"
                $LogEntry = $Message
            }
        }
        
        Write-Host $LogEntry -ForegroundColor $ForegroundColor -BackgroundColor Black
    
        if ($WriteLog) {
            Add-content -Path $LogFile -Value $LogEntry
        }
    
        if ($SendReport) {
            Add-content -Path $ReportFile -Value $LogEntry
        }
    }
}