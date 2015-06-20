r2d2
====

##Remote Rogue Device Detector
The need to detect rogue devices on a network is part of the first control listed in the
[SANS top 20 Critical Security Controls](http://www.sans.org/critical-security-controls).
The Remote Rogue Device Detector gathers data from various sources to compile a list
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

##Setup
Edit r2d2.pl to:
* define the DHCP server(s) to poll.
* define the AD domain controllers and domain which house the computer elements.

r2d2 needs to be run under an account that has permissions to access the DHCP server
via the netsh command.  You may need to run 'netsh add helper dhcpmon.dll' for dhcp
commands to work the first time.

The report that is generated includes a link to an SCCM server report that takes
a MAC and returns what it knows, if anything, about that MAC.
Search for the following and and fix it:
http://sccm/sccm/Report.asp?ReportID=37&variable=$mac

Run the script once with the --update option to get the latest MAC OUIs from IEEE.

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
##TODO (the old list, in no particular order)
* Move setup vaiables to a config file
* Use a real database instead of flat files
*	Add timestamp to entries for inclusion in a db
*	Find rogues with reservations to check if they are active 
*	Add commandline Option for DHCPservers
*	Add commandline Option for ports to ping?
*	Add notification - email, net send, other?
*	Track leases on foundb4 hosts and print an entry when it changes
*	Compare dhcpmac and nbmac, get vendor of nbmac?
*	Get WINS info?
*	Get vendor/OUI info dynamically?
*	GUI
*	How long to keep foundb4 hash?  Reset each day?
*	Add option to NOT load whitelist, blacklist, etc. each time through the main loop. 
		This would speed things up at the cost of filtering the latest changes.
*	Support different MAC formats for output, white and blacklists, vendor OUIs?

##History
The need an automated rogue detection process (for me) dates back over ten years ago.
At that time I wrote a perl script that looked for unknown domains on the network and
then used DHCP, WINS, and nbtstat to gather information on the rogue so we could track
it down.  A couple of jobs later, there was a similar need but a different environment.
The old script could not be used so I started over and r2d2 is the result of that effort.
A friend and former coworker encouraged me to publish it.  He took over the care
and feeding of r2d2 when I left that esteemed position.  He has even ported it to
Powershell and has graciously provided it here as well.
