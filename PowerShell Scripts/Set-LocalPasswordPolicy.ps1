$Computer = RC5
$User = "maksa"
$PasswordMaxAge = 90
$MinimumPasswordLenght = 8
$PasswordHistory = 5
psexec \\$Computer cmd /c "wmic UserAccount where Name=$User set PasswordExpires=True && net accounts /maxpwage:$PasswordMaxAge && net accounts /minpwlen:$MinimumPasswordLenght && net accounts /uniquepw:$PasswordHistory && net localgroup users $User /add && net localgroup administrators $User /delete"