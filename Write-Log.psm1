<#
.SYNOPSIS
Writes a log entry to console, log file and report file.

.DESCRIPTION
Creates a log entry with timestamp and message passed thru a parameter Message, and saves the log entry to log file, to report log
file, and writes the same entry to console. In "Settings.cfg" file paths to report log and permanent log file are contained, and
option to turn on or off whether a console output, report log and permanent log should be written. If "Settings.cfg" file is absent
it loads the default values. Depending on the NoTimestamp parameter, log entry can be written with or without a timestamp.
Format of the timestamp is "yyyy.MM.dd. HH:mm:ss:fff", and this function adds " - " after timestamp and before the main message.

.PARAMETER Message
A string message to be written as a log entry

.PARAMETER NoTimestamp
A switch parameter if present timestamp is disabled in log entry

.EXAMPLE
Write-Log -Message "A log entry"

.EXAMPLE
Write-Log "A log entry"

.EXAMPLE
Write-Log -Message "===========" -NoTimestamp

.EXAMPLE
"A log entry" | Write-Log

.NOTES
Version:        2.1
Author:         Zoran Jankov
#>
function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "A string message to be written as a log entry")]
        [string]
        $Message,

        [Parameter(Mandatory = $false,
                   Position = 1,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "A switch parameter if present timestamp is disabled in log entry")]
        [switch]
        $NoTimestamp = $false
    )

    begin {
        if (Test-Path -Path ".\Settings.cfg") {
            $Settings = Get-Content ".\Settings.cfg" | ConvertFrom-StringData

            $LogFile         = $Settings.LogFile
            $ReportFile      = $Settings.ReportFile
            $WriteTranscript = $Settings.WriteTranscript -eq "true"
            $WriteLog        = $Settings.WriteLog -eq "true"
            $SendReport      = $Settings.SendReport -eq "true"
        }
        else {
            $LogFile         = ".\Log.log"
            $ReportFile      = ".\Report.log"
            $WriteTranscript = $true
            $WriteLog        = $true
            $SendReport      = $false
        }
        if (-not (Test-Path -Path $LogFile)) {
            New-Item -Path $LogFile -ItemType File
        }
        if ((-not (Test-Path -Path $ReportFile)) -and $SendReport) {
            New-Item -Path $ReportFile -ItemType File
        }
    }

    process {
        if (-not($NoTimestamp)) {
            $Timestamp = Get-Date -Format "yyyy.MM.dd. HH:mm:ss:fff"
            $LogEntry = "$Timestamp - $Message"
        }
        else {
            $LogEntry = $Message
        }

        if ($WriteTranscript) {
            Write-Verbose $LogEntry -Verbose
        }
        if ($WriteLog) {
            Add-content -Path $LogFile -Value $LogEntry
        }
        if ($SendReport) {
            Add-content -Path $ReportFile -Value $LogEntry
        }
    }
}