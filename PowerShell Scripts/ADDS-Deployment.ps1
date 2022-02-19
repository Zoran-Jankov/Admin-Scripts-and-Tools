# Windows PowerShell script for AD DS Deployment

Import-Module ADDSDeployment

Install-ADDSForest -CreateDnsDelegation:$false `
                   -DatabasePath "C:\Windows\NTDS" `
                   -DomainMode "WinThreshold" `
                   -DomainName "its.com" `
                   -DomainNetbiosName "ITS" `
                   -ForestMode "WinThreshold" `
                   -InstallDns:$true `
                   -LogPath "C:\Windows\NTDS" `
                   -NoRebootOnCompletion:$false `
                   -SysvolPath "C:\Windows\SYSVOL" `
                   -Force:$true
