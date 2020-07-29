<#
.SYNOPSIS
Sends a Report.log file to defined email address

.DESCRIPTION
This function sends a report log file as an attachment to defined email address. In configuration hashtable parameter email
settings are defined.

.PARAMETER Configuration
A hashtable that contains information about report log file location, mail settings and weather report should be sent at all.

.PARAMETER FinalMessage
Additional variable information to be sent in the mail body.

.EXAMPLE
Send-Report -Configuration '.\Configuration.cfg' -FinalMessage "Successful script execution"

.NOTES
Version:        1.2
Author:         Zoran Jankov
#>
function Send-Report
{
    param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [Object[]]
        $Configuration,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $FinalMessage
    )
3
    if($Configuration.SendReport -eq "true")
    {
        $body = $Configuration.Body + "`n" + $FinalMessage

        Send-MailMessage -SmtpServer $Configuration.SmtpServer `
                         -Port $Configuration.Port `
                         -To $Configuration.To `
                         -From $Configuration.From `
                         -Subject $Configuration.Subject `
                         -Body $body `
                         -Attachments $Configuration.RreportFile
                         
        Remove-Item -Path $Configuration.RreportFile
    }
}