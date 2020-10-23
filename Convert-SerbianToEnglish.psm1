<#
.SYNOPSIS
Replaces all Serbian alphabet characters from a string with English alphabet characters.

.DESCRIPTION
This function takes a string written in Serbian language and returns a string with all Serbian alphabet characters replaced
with English alphabet characters.

.PARAMETER String
A string to be converted

.EXAMPLE
Convert-SerbianToEnglish -String "Škola Vuk Stefanović Karadžić"

.EXAMPLE
"Škola Vuk Stefanović Karadžić" | Convert-SerbianToEnglish

.NOTES
Version:        1.2
Author:         Zoran Jankov
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