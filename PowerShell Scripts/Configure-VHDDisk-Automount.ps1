# Replace <VHD UniqueID> with the UniqueID of the VHD you want to automount
$VHDUniqueId = "<VHD UniqueID>"

# Get the disk that corresponds to the VHD
$Disk = Get-Disk | Where-Object {$_.UniqueId -eq $VHDUniqueId}

# Get the partition on the disk
$Partition = Get-Partition -DiskNumber $Disk.Number

# Assign drive letter V to the partition
Set-Partition -PartitionNumber $Partition.PartitionNumber -NewDriveLetter "V"

# Enable automount for the disk
Set-Disk -Number $Disk.Number -IsOffline $false

# Get the volume that corresponds to the partition
$Volume = Get-Volume -Partition $Partition

# Enable automount for the volume
Set-Volume -DriveLetter $Volume.DriveLetter -Automount $true
