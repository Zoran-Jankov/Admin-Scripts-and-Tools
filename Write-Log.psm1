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

.PARAMETER LogSeparator
Parameter description

.PARAMETER LogTitle
Parameter description

.EXAMPLE
An example

.NOTES
Version:        1.8
Author:         Zoran Jankov
#>
function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Message = "ERROR - No log entry passed",

        [Parameter(Mandatory = $false)]
        [switch]
        $LogSeparator = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $LogTitle = $false
    )

    begin {
        if (Test-Path -Path '.\Settings.cfg') {
            $Settings = Get-Content '.\Settings.cfg' | ConvertFrom-StringData

            $LogFile         = $Settings.LogFile
            $ReportFile      = $Settings.ReportFile
            $WriteTranscript = $Settings.WriteTranscript -eq "true"
            $WriteLog        = $Settings.WriteLog -eq "true"
            $SendReport      = $Settings.SendReport -eq "true"
        }
        else {
            $LogFile         = '.\Log.log'
            $ReportFile      = '.\Report.log'
            $WriteTranscript = $true
            $WriteLog        = $true
            $SendReport      = $true
        }
        if (-not (Test-Path -Path $LogFile)) {
            New-Item -Path $LogFile -ItemType File
        }
        if ((-not (Test-Path -Path $ReportFile)) -and $SendReport) {
            New-Item -Path $ReportFile -ItemType File
        }
    }

    process {
        if (-not($LogSeparator -or $LogTitle)) {
            $Timestamp = Get-Date -Format "yyyy.MM.dd. HH:mm:ss:fff"
            $LogEntry = $Timestamp + " - " + $Message
        }
        elseif ($LogSeparator -and (-not $LogTitle)) {
            $LogEntry = $Settings.LogSeparator
        }
        elseif ((-not $LogSeparator) -and $LogTitle) {
            $LogEntry = $Settings.LogTitle
        }
        else {
            $LogEntry = "ERROR - Wrong log entry"
        }

        if ($WriteTranscript) {
            Write-Output $LogEntry -Verbose
        }
        if ($WriteLog) {
            Add-content -Path $LogFile -Value $LogEntry
        }
        if ($SendReport) {
            Add-content -Path $ReportFile -Value $LogEntry
        }
    }
}