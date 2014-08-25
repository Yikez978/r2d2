r2d2
====

##Remote Rogue Device Detector
The need to detect rogue devices on a network is part of the first control listed in the
[SANS top 20 Critical Security Controls](http://www.sans.org/critical-security-controls).
The Remote Rogue Device Detection gathers data from various sources to compile a list
of potential rogue devices.

Originally designed to run on a Windows network, it uses:
* DHCP
* netsh.exe (to pull the dhcp leases)
* Active Directory
* dsquery.exe (to pull AD entries)
* SCCM
* NBTStat.exe

It can check for open ports to see if it appears to be running agents or services you might
expect on a valid device.

Also resolves the vendor OUI from the MAC address to aid in tracking down the device.

The found devices can be whitelisted or blacklisted to indicate that they have been previously
investigated and their status determined.

##How to Run
```
Edit the script near the top to:
    set the DHCP server(s)' IP address(es)

To run without options, from a command prompt enter:
perl r2d2.pl

Options:
	--sleep		time in seconds to wait to run again after completing.
			Default is 0 = run once and exit.  Max is 86400 (24 hours).
	--verbose	print additional info to screen while running
	--update	update the vendor.txt file and exit
	--listall	save all computer and printer names, DCHP scopes and leases
			while otherwise running the script normally.
	--help		print this help and exit

When run continously, only new devices are reported.

NOTE: May need to run 'netsh add helper dhcpmon.dll' for dhcp commands to work the first time.
      Need Microsoft's dsquery.exe to get computer and printer names from AD.
```
