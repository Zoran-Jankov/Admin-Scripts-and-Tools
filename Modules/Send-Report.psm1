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
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName)]
        [hashtable]
        $Configuration,

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName)]
        [System.Collection.ArrayList]
        $Log
    )

    if($Configuration.SEND_REPORT -eq "true")
    {
        #Creating report log file
        New-Item -Path '.\Report.log' -ItemType File
        $report = '.\Report.log'
        Add-content -Path $report -Value $Log

        $body = $Configuration.Body + "`n" + $FinalMessage
        Send-MailMessage -SmtpServer $Configuration.SmtpServer `
                         -Port $Configuration.Port `
                         -To $Configuration.To `
                         -From $Configuration.From `
                         -Subject $Configuration.Subject `
                         -Body $body `
                         -Attachments $report
                         
        Remove-Item -Path $report
    }
}