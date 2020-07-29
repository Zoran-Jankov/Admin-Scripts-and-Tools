
function New-TransferDrive
{
    param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [char]
        $Drive,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Position=3, Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-Module '.\Write-Log.psm1'

    if(Test-Connection -TargetName $ComputerName -Quiet -Count 1)
	{
		$message = "Successfully accessed " + $ComputerName + " remote computer"
		Write-Log Write-Log -OperationSuccessful "Successful"-Message $message

        #Network path creation to D partition on the remote computer
        $partition = "\D$"
		$networkPath = "\\" + $ComputerName + $partition

		#Try to create network drive to D partition on the remote computer
        if(New-PSDrive -Name $Drive -PSProvider "FileSystem" -Root $networkPath -Credential $Credential)
        {
            $message = "Successfully mapped network drive to D partition on the " + $ComputerName + " remote computer"
            Write-Log -OperationSuccessful "Successful" -Message $message
            $operationSuccessful = $true
        }
        else
        {
            $message = "Failed to map network drive to D partition on the " + $ComputerName + " remote computer"
            Write-Log -OperationSuccessful "Failed" -Message $message

            #Network path creation to C partition on the remote computer
            $partition = "\C$"
		    $networkPath = "\\" + $ComputerName + $partition
            
            #Try to create network drive to C partition on the remote computer
            if(New-PSDrive -Name $Drive -PSProvider "FileSystem" -Root $networkPath -Credential $Credential)
            {
                $message = "Successfully mapped network drive to C partition on the " + $ComputerName + " remote computer"
                Write-Log -OperationSuccessful "Successful" -Message $message
                $operationSuccessful = $true
            }
            else
            {
                $message = "Failed to map network drive to C partition on the " + $ComputerName + " remote computer - Credential not valid"
                Write-Log -OperationSuccessful "Failed" -Message $message
                $operationSuccessful = $false
            }
        }
	}
    else
    {
		$message = "Failed to access " + $ComputerName + " remote computer"
        Write-Log -OperationSuccessful "Failed" -Message $message
        $operationSuccessful = $false
    }

    return $operationSuccessful
}