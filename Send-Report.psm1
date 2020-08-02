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
function Send-Report
{
    param
    (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $FinalMessage
    )

    $configuration = Get-Content '.\Configuration.cfg' | ConvertFrom-StringData

    if($configuration.SendReport -eq "true")
    {
        $body = $configuration.Body + "`n" + $FinalMessage

        Send-MailMessage -SmtpServer $configuration.SmtpServer `
                         -Port $configuration.Port `
                         -To $configuration.To `
                         -From $configuration.From `
                         -Subject $configuration.Subject `
                         -Body $body `
                         -Attachments $configuration.ReportFile
                         
        Remove-Item -Path $configuration.ReportFile
    }
}