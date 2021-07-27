$LanguageList = New-WinUserLanguageList -Language "sr-Latn-RS"
$LanguageList.Add("en-US")
$LanguageList.Add("sr-Cyrl-RS")

Set-WinUserLanguageList -LanguageList $LanguageList -Confirm:$false -Force