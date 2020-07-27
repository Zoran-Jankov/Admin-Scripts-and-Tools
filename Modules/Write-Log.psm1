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
Version:        1.1
Author:         Zoran Jankov
Creation Date:  21.07.2020.
Update Date:    23.07.2020.	
#>
function Write-Log
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$false)]
        [hashtable]
        $Configuration,
        
        [Parameter(Position=1, Mandatory=$false, ValueFromPipeline=$true)]
        [String]
        $Message,

        [Parameter(Position=2, Mandatory=$false, ValueFromPipeline=$false)]
        [String]
        $LogSeparator
    )

    begin
    {
        $log = [System.Collections.ArrayList]::new()
    }

    process
    {
        if($LogSeparator -eq $null)
        {
            $timestamp = Get-Date -Format "yyyy.MM.dd. HH:mm:ss:fff"
    	    $logEntry = $timestamp + " - " + $Message
        }
        else
        {
            $logEntry = $LogSeparator
        }

        $log.Add($logEntry)

        if($Configuration.WRITE_OUTPUT -eq "true")
        {
            Write-Output $logEntry
        }

        if($Configuration.WRITE_LOG -eq "true")
        {
            Add-content -Path $Configuration.LOG -Value $log
        }
    }
        
    end
    {
        return [System.Collection.ArrayList]$log
    }
}