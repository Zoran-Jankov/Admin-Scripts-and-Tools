# Set variables
$SourceFolder = "C:\FolderToCompress"
$ZipPath = "C:\CompressedFolder"
$DestinationFolder = "\\NetworkLocation\FolderToCopyTo"
$LogFile = "\\NetworkLocation\LogFile_$(Get-Date -Format 'yyyy.MM.dd. HH:mm:ss:fff').log"
$EmailFrom = "sender@gmail.com"
$EmailTo = "recipient@example.com"
$EmailSubject = "7zip compression and copy report"
$EmailSmtpServer = "smtp.gmail.com"
$EmailUsername = "sender@gmail.com"
$EmailPassword = "password"

try {
    # Get all folders in the source folder
    $Folders = Get-ChildItem $SourceFolder -Directory

    # Loop through each folder
    foreach ($Folder in $Folders) {
        # Get the timestamp for the folder in yyyy-MM-dd format
        $Timestamp = Get-Date -Format 'yyyy-MM-dd'

        # Set the name for the compressed file
        $ZipFile = "$ZipPath\$($Folder.Name)_$Timestamp.7z"

        # Compress folder using 7zip
        & "C:\Program Files\7-Zip\7z.exe" a -t7z $ZipFile $Folder.FullName -mx=9

        # Log compression success to log file
        Add-Content $LogFile "$(Get-Date -Format 'yyyy.MM.dd. HH:mm:ss:fff') - $($Folder.Name) folder compression succeeded."

        # Copy folder to network location using Robocopy
        Robocopy $ZipFile $DestinationFolder /MIR /W:5 /R:2 /LOG+:$LogFile

        # Log copy success to log file
        Add-Content $LogFile "$(Get-Date -Format 'yyyy.MM.dd. HH:mm:ss:fff') - $($Folder.Name) folder copy succeeded."

        # Clean up compressed folder
        Remove-Item $ZipFile

        # Log clean-up success to log file
        Add-Content $LogFile "$(Get-Date -Format 'yyyy.MM.dd. HH:mm:ss:fff') - $($Folder.Name) folder compressed file clean-up succeeded."
    }

    # Log success to log file
    Add-Content $LogFile "$(Get-Date -Format 'yyyy.MM.dd. HH:mm:ss:fff') - 7zip compression and copy succeeded for all folders in $($SourceFolder)."

} catch {
    # Log error to log file
    Add-Content $LogFile "$(Get-Date -Format 'yyyy.MM.dd. HH:mm:ss:fff') - Error occurred: $($_.Exception.Message)"

    # Send email report with error details
    $EmailBody = "An error occurred while compressing and copying folders. Check $LogFile for details."
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $EmailBody -SmtpServer $EmailSmtpServer -Credential (New-Object System.Management.Automation.PSCredential ($EmailUsername, (ConvertTo-SecureString $EmailPassword -AsPlainText -Force)))
}
