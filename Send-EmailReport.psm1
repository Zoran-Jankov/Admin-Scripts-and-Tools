<#
.SYNOPSIS
Sends a Report.log file to defined email address

.DESCRIPTION
This function sends a report log file, Report.log, as an attachment to defined email address.
settings are defined.

.PARAMETER FinalMessage
Additional variable information to be sent in the mail body.

.EXAMPLE
Send-Report -FinalMessage "Successful script execution"

.NOTES
Version:        1.6
Author:         Zoran Jankov
#>
function Send-EmailReport {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FinalMessage
    )

    begin {
        $Settings = Get-Content '.\Settings.cfg' | ConvertFrom-StringData
    }

    process {
        if ($Settings.SendReport -eq 'true') {
            $Body = $Settings.Body + "`n" + $FinalMessage
            Send-MailMessage -SmtpServer $Settings.SmtpServer `
                             -Port $Settings.Port `
                             -To $Settings.To `
                             -From $Settings.From `
                             -Subject $Settings.Subject `
                             -Body $Body `
                             -Attachments $Settings.ReportFile
            Remove-Item -Path $Settings.ReportFile
        }
    }
}