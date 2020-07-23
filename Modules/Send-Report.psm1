<#
.SYNOPSIS
Sends a Report.log file to defined email address

.DESCRIPTION
This function sends a Report.log file as an attachment to defined email address
#>
function Send-Report
{
    param
    (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$false)]
        $Configuration,

        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$false)]
        [string]$FinalMessage

    )

    if($Configuration.SEND_REPORT -eq "true")
    {
        $body = $Configuration.BODY + "`n" + $FinalMessage
        Send-MailMessage -SmtpServer $Configuration.SMTP `
                         -Port $Configuration.PORT `
                         -To $Configuration.RECEIVER `
                         -From $Configuration.SENDER `
                         -Subject $Configuration.SUBJECT `
                         -Body $body `
                         -Attachments $report
    }
	Remove-Item -Path $report
}