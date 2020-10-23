<#
.SYNOPSIS
Sends a Report.log file to defined email address

.DESCRIPTION
This function sends a report log file, Report.log, as an attachment to defined email address.
settings are defined.

.PARAMETER Settings
Email settings

.PARAMETER FinalMessage
Additional variable information to be sent in the mail body

.EXAMPLE
Send-Report -Setting $Settings -FinalMessage "Successful script execution"

.EXAMPLE
$Settings | Send-Report

.NOTES
Version:        1.7
Author:         Zoran Jankov
#>
function Send-EmailReport {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Object[]]
        $Settings,

        [Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FinalMessage
    )

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