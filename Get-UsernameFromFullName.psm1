function Get-UserNameFromFullName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $FullName,

        [Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [switch]
        $ReverseNamePositions = $false
    )

    begin
    {
        if ($ReverseNamePositions)
        {
            $Front = -1
            $End = 0
        }
        else
        {
            $Front = 0
            $End = -1
        }
    }

    process
    {
        $UserNameComponents = $FullName.Trim().ToLower().Split(' ')

        $UserName = '{0}.{1}' -f $UserNameComponents[$Front], $UserNameComponents[$End]

        $UserName -replace 'č', 'c' `
                  -replace 'č', 'c' `
                  -replace 'ć', 'c' `
                  -replace 'đ', 'dj' `
                  -replace 'š', 's' `
                  -replace 'ž', 'z'
    }
}