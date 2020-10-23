<#
.SYNOPSIS
Converts a full name to username in english alphabet

.DESCRIPTION
Converts a full name to username in english alphabet in format "jon.dow". Optionaly first and last name positions can be reversed
with ReverseNamePositions parameter.

.PARAMETER FullName
User's full name

.PARAMETER ReverseNamePositions
Optional switch to reverse first and last name positions

.EXAMPLE
Get-UserNameFromFullName -FullName "Jankov Zoran" -ReverseNamePositions

.EXAMPLE
"Jankov Zoran" | Get-UserNameFromFullName

.NOTES
Version:        1.4
Author:         Zoran Jankov
#>
function Get-UserNameFromFullName {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FullName,

        [Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [switch]
        $ReverseNamePositions = $false
    )

    begin {
        if ($ReverseNamePositions) {
            $Front = -1
            $End = 0
        }
        else {
            $Front = 0
            $End = -1
        }
    }

    process {
        $UserNameComponents = $FullName.Trim().ToLower().Split(" ")
        $UserName = '{0}.{1}' -f $UserNameComponents[$Front], $UserNameComponents[$End]
        Convert-SerbianToEnglish -String $UserName
        return $UserName
    }
}