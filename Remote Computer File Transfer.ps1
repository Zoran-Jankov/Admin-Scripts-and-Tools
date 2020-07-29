<#
.SYNOPSIS
This script transfers files to remote computers.

.DESCRIPTION
This script transfers files to remote computers. In '.\Files Paths.txt' file user can write full paths to files for transfer, and
in '.\Remote Computers.txt' user can write list of remote computers to which files are transferred, ether by hostname or IP address.
Script generates detailed log file, '.\File Transfer Log.log', and report that is sent via email to system administrators.

.NOTES
Version:        1.5
Author:         Zoran Jankov
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
#Importing modules
Import-Module '.\Write-Log.psm1'
Import-Module '.\New-TransferDrive.psm1'
Import-Module '.\Deploy-Folder.psm1'
Import-Module '.\Start-FileTransfer.psm1'
Import-Module '.\Send-Report.psm1'

#Clears the contents of the DNS client cache
Clear-DnsClientCache

#Loading script configuration
$configuration = Get-Content '.\Remote Computer File Transfer Configuration.cfg' | Select-Object | ConvertFrom-StringData

#Defining network drive thru which files will be to transferred
$networkDrive = 'T'

#Initializing report file
New-Item -Path $configuration.ReportFile -ItemType File
$report = $configuration.ReportFile

$fileList = Get-Content -Path $configuration.FileList
$computerList = Get-Content -Path $configuration.ComputerList

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Write-Log -LogSeparator $configuration.LogTitle
Write-Log -LogSeparator $configuration.LogSeparator

#Get credential from user input
$credential = Get-Credential

$message = "User " + $credential.UserName + " entered credentials"
Write-Log -Message $message

foreach($file in $fileList)
{
	if((Test-Path -Path $file) -eq $true)
	{
		$message = "Successfully checked " + $file + " file - ready for transfer."
		Write-Log -OperationSuccessful "Successful" -Message $message
	}
	else
	{
        $message = "Failed to access " + $file + " file. It does not exist."
        Write-Log -OperationSuccessful "Failed" -Message $message
        $message = "Script stopped - MISSING FILE ERROR"
		Write-Log -OperationSuccessful "Failed" -Message $message
		Write-Log -Message $configuration.LogSeparator
		Send-Report -Configuration $configuration -FinalMessage $message
		Exit
	}
}

Write-Log -OperationSuccessful "Successful" -Message "Successfully accessed all files - ready for transfer."

#Start file transfer
Write-Log -Message "Started file transfer"
foreach($computer in $computerList)
{








	#Network drive removal
	Remove-PSDrive -Name $networkDrive
	$message = "Successfully removed network drive from " + $computer + " remote computer"
	Write-Log -Message $message
}

$message = "Completed Remote Computer File Transfer PowerShell Script"
Write-Log -Message $message
Write-Log -LogSeparatot $logSeparator

#Sends email with detailed report and deletes temporary report log file
Send-Report -Configuration $configuration -FinalMessage $message