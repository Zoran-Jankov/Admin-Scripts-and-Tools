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
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FinalMessage
    )

    begin {
        $Configuration = Get-Content '.\Configuration.cfg' | ConvertFrom-StringData
    }

    process {
        if ($Configuration.SendReport -eq "true") {
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