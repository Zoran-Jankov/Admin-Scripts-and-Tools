<#
.SYNOPSIS
Writes a log entry

.DESCRIPTION
Creates a log entry with timestamp and message passed thru a parameter $Message or thru pipeline, and saves the log entry to log
file, to report log file, and writes the same entry to console. $configuration parameter contains path to configuration.inf file
in witch paths to report log and permanent log file are contained, and option to turn on or off whether a report log, permanent
log and console write should be written. This function can be called to write a log separator, and this entries do not have a
timestamp. Format of the timestamp is "yyyy.MM.dd. HH:mm:ss:fff" and this function adds " - " after timestamp and before the main
message.

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
        [String]$OperationResult = 'None',
        
        [Parameter(Position = 1, Mandatory, ValueFromPipelineByPropertyName)]
        [String]
        $Message
    )

    $timestamp = Get-Date -Format "yyyy.MM.dd. HH:mm:ss:fff"
    $logEntry = $timestamp + " - " + $Message
        
    switch ($OperationResult) {
        'Success' {
            $foregroundColor = 'Green'
            break
        }

        'Fail' {
            $foregroundColor = 'Red'
            break
        }

        'Partial' {
            $foregroundColor = 'Yellow'
            break
        }

        'Info' {
            $foregroundColor = 'Cyan'
            break
        }

        'None' { 
            $foregroundColor = 'White'
            $logEntry = $Message
        }
    }
    
    $configuration = Get-Content '.\Configuration.cfg' | ConvertFrom-StringData

    if ($configuration.WriteHost -eq "true") {
        Write-Host $logEntry -ForegroundColor $foregroundColor -BackgroundColor Black
    }

    if ($configuration.WriteLog -eq "true") {
        Add-content -Path $configuration.LogFile -Value $logEntry
    }

    if ($configuration.SendReport -eq "true") {
        Add-content -Path $configuration.ReportFile -Value $logEntry
    }
}