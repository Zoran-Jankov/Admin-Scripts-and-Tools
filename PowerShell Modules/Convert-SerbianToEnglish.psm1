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
Convert-SerbianToEnglish "Škola Vuk Stefanović Karadžić"

.EXAMPLE
"Škola Vuk Stefanović Karadžić" | Convert-SerbianToEnglish

.NOTES
Version:        1.3
Author:         Zoran Jankov
#>
function Convert-SerbianToEnglish {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = "A string to be converted")]
        [string]
        $String
    )
    process {
        return (
            $String -replace "č", "c" `
                    -replace "ć", "c" `
                    -replace "đ", "dj" `
                    -replace "š", "s" `
                    -replace "ž", "z" `
                    -replace "Č", "C" `
                    -replace "Ć", "C" `
                    -replace "Đ", "Dj" `
                    -replace "Š", "S" `
                    -replace "Ž", "Z"
        )
    }
}