<#
.SYNOPSIS
Sends a Report.log file to defined email address

.DESCRIPTION
This function sends a Report.log file as an attachment to defined email address. In Configuration hashtable parameter email
settings are defined.

.PARAMETER Configuration
Parameter Configuration is a hashtable that contains

.PARAMETER Log
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Send-Report
{
    param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [Object[]]
        $Configuration,

        [Parameter(Position=1, Mandatory=$true)]
        [System.Collection.ArrayList]
        $Log
    )

    if($Configuration.SendReport -eq "true")
    {
        #Creating report log file
        New-Item -Path '.\Report.log' -ItemType File
        $report = '.\Report.log'
        Add-content -Path $report -Value $Log.

        $body = $Configuration.Body + "`n" + $Log.get($Log.size() - 1)

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