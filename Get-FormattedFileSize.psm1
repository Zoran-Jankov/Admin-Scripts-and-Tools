<#
.SYNOPSIS
Returns string value from long integer value representing bytes in [12.45 MB] format.

.DESCRIPTION
The function takes in a long integer value representing bytes, and Returns string value in [12.45 MB] format.

.PARAMETER Size
Long integer representing bytes

.EXAMPLE
Get-FormattedFileSize -Size 1234567890

.EXAMPLE
Get-FormattedFileSize 1234567890

.EXAMPLE
1234567890 | Get-FormattedFileSize

.NOTES
Version:        1.3
Author:         Zoran Jankov
#>
function Get-FormattedFileSize {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "Long integer representing bytes")]
        [long]
        $Size
    )

    if ($Size -gt 1TB) {
        $StringValue = [string]::Format('{0:0.00} TB', $Size / 1TB)
    }
    elseIf ($Size -gt 1GB) {
        $StringValue = [string]::Format('{0:0.00} GB', $Size / 1GB)
    }
    elseIf ($Size -gt 1MB) {
        $StringValue = [string]::Format('{0:0.00} MB', $Size / 1MB)
    }
    elseIf ($Size -gt 1KB) {
        $StringValue = [string]::Format('{0:0.00} kB', $Size / 1KB)
    }
    else {
        $StringValue = [string]::Format('{0:0} B', $Size)
    }
    return $StringValue
}