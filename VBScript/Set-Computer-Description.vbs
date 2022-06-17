Set objSysInfo = CreateObject("ADSystemInfo")
Set objComputer = GetObject("LDAP://" & objSysInfo.ComputerName)
Set objUser = GetObject("LDAP://" & objSysInfo.UserName)
	
strComputer = "." 
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
Set colComputerSystem = objWMIService.ExecQuery ("Select * from Win32_computersystem") 
Set colBIOS = objWMIService.ExecQuery ("Select * from Win32_BIOS")

For each objComputerSystem in colComputerSystem 
	GetComputerManufacturer = objComputerSystem.Manufacturer
	GetComputerModel = objComputerSystem.Model
	TotalPhysicalMemory = Round(objComputerSystem.TotalPhysicalMemory/1073741824)
Next

For each objBIOS in colBIOS
	GetSerialNumber = objBIOS.SerialNumber
Next

Set colProcessors = objWMIService.ExecQuery("Select * from Win32_Processor")
For Each objProcessor in colProcessors
	Processor = objProcessor.Name
Next

txtCount = InStr(GetComputerManufacturer," ") - 1
GetComputerManufacturer = GetComputerManufacturer
GetSerialNumber = Replace(GetSerialNumber, " ", "")

strDate = Year(Date) & "." & Month(Date) & "." & Day(Date)
strCompDesc = strDate & " | " & objUser.SAMAccountName & " | " & GetComputerManufacturer & " " & GetComputerModel & " | SN:" & GetSerialNumber & " | CPU: " & Processor & " | RAM: " & TotalPhysicalMemory & " GB"
strCompDesc = Left(strCompDesc,1024)

If strCompDesc = objComputer.description Then
	wscript.Quit
Else
	objComputer.Description = strCompDesc
	objComputer.SetInfo
End If
