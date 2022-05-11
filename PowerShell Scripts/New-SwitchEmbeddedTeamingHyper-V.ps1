<#
Deploying Switch Embedded Teaming (SET) on Hyper-V

Introduction

In Windows Server 2012 and 2012 R2, Microsoft introduced NIC Teaming natively in the OS where you can have a collection of NICs
up to 32 maximum, and create your team of those NICs through the UI (lbfoadmin) or using PowerShell by defining the load balancing
algorithm and the teaming mode. You build your team and then if you want to bind the virtual switch to that team using Hyper-V to
allow Virtual Machines to communicate out through that team set of adapters, then you go across Hyper-V Manager or PowerShell and
create your Virtual Switch and bind it to that Team, in either way its multiple steps, the virtual switch and the team are two
separate constructs. If you want to deep dive into Microsoft NIC Teaming in Windows Server 2012 R2 and later release, I highly 
recommend checking my earlier post about Microsoft NIC Teaming.

Switch Embedded Teaming (SET) overview

With the release of Windows Server 2016, Microsoft introduced a new type of teaming approach called Switch Embedded Teaming (SET)
which is a virtualization-aware, how is that different from NIC Teaming, the first part is embedded into the Hyper-V virtual switch,
which means a couple of things, the first one you don’t have any team interfaces anymore, you won’t be able to build anything extra
on top of it, you can’t set a property on the team because it’s part of the virtual switch, you set all the properties directly on
the vSwitch. SET is targeted to support Software Defined Networking (SDN) switch capabilities, it’s not a general-purpose use 
everywhere teaming solution that NIC Teaming was intended to be. So this is specifically integrated with Packet Direct, Converged
RDMA vNIC, and SDN-QoS. It’s only supported when using the SDN-Extension. Packet Direct provides a high network traffic throughput
and low-latency packet processing infrastructure.At the time of writing this article, the following list of networking features 
are compatible and not compatible in Windows Server 2016:

SET is compatible with:

Datacenter bridging (DCB).
Hyper-V Network Virtualization – NV-GRE and VxLAN are both supported in Windows Server 2016 Technical Preview.
Receive-side Checksum offloads (IPv4, IPv6, TCP) – These are supported if any of the SET team members support them.
Remote Direct Memory Access (RDMA).
SDN Quality of Service (QoS).
Transmit-side Checksum offloads (IPv4, IPv6, TCP) – These are supported if all of the SET team members support them.
Virtual Machine Queues (VMQ).
Virtual Receive Side Scaling (RSS).

SET is not compatible with:

802.1X authentication.
IPsec Task Offload (IPsecTO).
QoS in the host or native OSs.
Receive side coalescing (RSC).
Receive side scaling (RSS).
Single root I/O virtualization (SR-IOV).
TCP Chimney Offload.
Virtual Machine QoS (VM-QoS).

SET Modes and Settings:

Switch independent teaming mode only.
Dynamic and Hyper-V port mode load distributions only.
Managed by SCVMM or PowerShell, no GUI.
Only team’s identical ports (same manufacturer, same driver, same capabilities) (e.g., dual or quad-port NIC).
The switch must be created in SET mode. (SET can’t be added to the existing switch; you cannot change it later).
Up to eight physical NICs maximum into one or more software-based virtual network adapters.
The use of SET is only supported in Hyper-V Virtual Switch in Windows Server 2016 or later release.
You cannot deploy SET in Windows Server 2012 R2.
#>

New-VMSwitch -Name SETswitch -NetAdapterName "Ethernet1","Ethernet2" -EnableEmbeddedTeaming $true
