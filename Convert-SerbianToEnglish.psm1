<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER String
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Convert-SerbianToEnglish {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $String
    )
    process {
        $String.Replace('č', 'c').
                Replace('ć', 'c').
                Replace('đ', 'dj').
                Replace('š', 's').
                Replace('ž', 'z').
                Replace('Č', 'C').
                Replace('Ć', 'C').
                Replace('Đ', 'Dj').
                Replace('Š', 'S').
                Replace('Ž', 'Z')
        return $String
    }
}