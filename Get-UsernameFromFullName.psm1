function Get-UsernameFromFullName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $FullName,

        [Parameter(Position = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('First', 'Last')]
        [string]
        $LastNamePosition = 'First'
    )
    
    $usernameComponents = $FullName.ToLower().Split(" ")

    switch ($LastNamePosition)
    {
        'First' { $firstName = $usernameComponents.Length - 1; $lastName = 0 }
        'Last'  { $firstName = 0; $lastName = $usernameComponents.Length - 1 }
        Default { $firstName = $usernameComponents.Length - 1; $lastName = 0 }
    }

    $chars = ($usernameComponents.Get($firstName) + "." + $usernameComponents.Get($lastName)).ToCharArray()

    foreach($char in $chars)
    {
        switch($char)
        {
            'ć' { $segment = "c" }
            'č' { $segment = "c" }
            'đ' { $segment = "dj" }
            'š' { $segment = "s" }
            'ž' { $segment = "z" }
            default { $segment = $char }
        }
        $Username += $segment
    }
    return $Username
}