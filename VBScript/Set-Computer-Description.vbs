' Get list of logged in users
Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("quser")
strOutput = objExec.StdOut.ReadAll

' Parse output to get usernames
Set re = New RegExp
re.Pattern = "([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)"
re.Global = True
Set matches = re.Execute(strOutput)

strUsernames = ""
For Each match In matches
    If match.SubMatches(3) = "Active" Then
        strUsernames = strUsernames & match.SubMatches(0) & ","
    End If
Next

' Remove trailing comma from usernames string
If Right(strUsernames, 1) = "," Then
    strUsernames = Left(strUsernames, Len(strUsernames) - 1)
End If

' Get computer information
Set objSysInfo = CreateObject("ADSystemInfo")
Set objComputer = GetObject("LDAP://" & objSysInfo.ComputerName)

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colComputerSystem = objWMIService.ExecQuery ("Select * from Win32_computersystem")
Set colBIOS = objWMIService.ExecQuery ("Select * from Win32_BIOS")
Set colProcessors = objWMIService.ExecQuery("Select * from Win32_Processor")

For Each objComputerSystem in colComputerSystem
    strManufacturer = Trim(objComputerSystem.Manufacturer)
    strModel = Trim(objComputerSystem.Model)
    intMemory = Round(objComputerSystem.TotalPhysicalMemory/1073741824)
Next

For Each objBIOS in colBIOS
    strSerialNumber = Trim(objBIOS.SerialNumber)
Next

For Each objProcessor in colProcessors
    strProcessor = Trim(objProcessor.Name)
Next

' Format computer description
strDate = Year(Date) & "." & Right("0" & Month(Date), 2) & "." & Right("0" & Day(Date), 2)
strCompDesc = strDate & " | " & strManufacturer & " " & strModel & " | SN:" & strSerialNumber & " | CPU: " & strProcessor & " | RAM: " & intMemory & " GB | Logged in users: " & strUsernames

' Trim description to 1024 characters
strCompDesc = Left(strCompDesc, 1024)

' Update computer description in Active Directory
If strCompDesc <> objComputer.Description Then
    objComputer.Description = strCompDesc
    objComputer.SetInfo
End If
