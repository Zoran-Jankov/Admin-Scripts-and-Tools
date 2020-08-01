<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Size
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-FormattedFileSize
{
    param
    (
        [Parameter(Position = 0, Mandatory = $true)]
        [long]
        $Size
    )


    If($Size -gt 1TB)
    {
        $stringValue = [string]::Format("{0:0.00} TB", $Size / 1TB)
    }
    elseIf($Size -gt 1GB)
    {
        $stringValue = [string]::Format("{0:0.00} GB", $Size / 1GB)
    }
    elseIf($Size -gt 1MB)
    {
        $stringValue = [string]::Format("{0:0.00} MB", $Size / 1MB)
    }
    elseIf($Size -gt 1KB)
    {
        $stringValue = [string]::Format("{0:0.00} kB", $Size / 1KB)
    }
    else
    {
        $stringValue = [string]::Format("{0:0.00} B", $Size)
    }

    return $stringValue
}