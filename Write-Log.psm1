<#
.SYNOPSIS
Writes a log entry

.DESCRIPTION
Creates a log entry with timestamp and message passed thru a parameter $Message or thru pipeline, and saves the log entry to log
file, to report log file, and writes the same entry to console. $Configuration parameter contains path to Configuration.inf file
in witch paths to report log and permanent log file are contained, and option to turn on or off whether a report log, permanent
log and console write should be written. This function can be called to write a log separator, and this entries do not have a
timestamp. Format of the timestamp is "yyyy.MM.dd. HH:mm:ss:fff" and this function adds " - " after timestamp and before the main
message.

.PARAMETER Configuration
Parameter description

.PARAMETER Message
Parameter description

.PARAMETER LogSeparator
Parameter description

.EXAMPLE
An example

.NOTES
Version:        1.3
Author:         Zoran Jankov
#>
function Write-Log
{
    param
    (
        [Parameter(Position = 0, Mandatory = $true)]
        [Object[]]
        $Configuration,

        [Parameter(Position = 1, Mandatory = $false)]
        [String]
        $OperationSuccessful,
        
        [Parameter(Position = 2, Mandatory = $false)]
        [String]
        $Message,

        [Parameter(Position = 3, Mandatory = $false)]
        [String]
        $LogSeparator
    )
    if($LogSeparator -eq $null)
    {
        $timestamp = Get-Date -Format "yyyy.MM.dd. HH:mm:ss:fff"
    	$logEntry = $timestamp + " - " + $Message
    }
    else
    {
            $logEntry = $LogSeparator
    }

    if($Configuration.WriteHost -eq "true")
    {
        if($OperationSuccessful -eq "Successful")
        {
            Write-Host $logEntry -ForegroundColor Green -BackgroundColor Black
        }
        elseif($OperationSuccessful -eq "Failed")
        {
            Write-Host $logEntry -ForegroundColor Red -BackgroundColor Black
        }
        elseif($OperationSuccessful -eq "Partial")
        {
            Write-Host $logEntry -ForegroundColor Blue -BackgroundColor Black
        }
        else
        {
            Write-Host $logEntry -ForegroundColor Yellow -BackgroundColor Black
        }
    }

    if($Configuration.WriteLog -eq "true")
    {
        Add-content -Path $Configuration.LogFile -Value $logEntry
    }

    if($Configuration.SendReport -eq "true")
    {
        Add-content -Path $Configuration.ReportFile -Value $logEntry
    }
}