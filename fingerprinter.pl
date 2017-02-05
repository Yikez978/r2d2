#! /usr/bin/perl
# Written by Eric McCullough
#
# fingerprinter.pl
# compare a device to a fingerprint
# pass if all conditions are met
# fail if not
# no status if no response?

use strict;
use Win32::NetResource qw(:DEFAULT NetShareGetInfo GetError);
use JSON;

use c3p0; # shared subroutines

my $host_ip = shift;

my ($year, $mon, $mday, $hour, $min) = gettime();
print STDERR "Fingerprinting host [$host_ip] at $hour:$min of $mon/$mday/$year\n\n";

my $pingable = pinghost($host_ip);
my $p4445 = pingport($host_ip, 4445); # encase agent
my $p80 = pingport($host_ip, 80); # web port, maybe printer mgmt interface
my $sav = &pingport($host_ip, 2967); # Symantec AV agent
my $epo = &pingport($host_ip, 591); # McAfee EPO agent

# netbios info and shares
my $cshare;
my %SHARE; # used in call to NetShareGetInfo
if ($pingable eq "Y") {
  if (NetShareGetInfo( "c\$", \%SHARE, $host_ip )) { $cshare = 'Y'; } # check for access to the c$ share.
  ################ Need equivalent command for NBTstat in linux... #####################
  #  alias nbtstat='nmblookup -S -U <server> -R'
  # part of samba
  open(NBTSTAT, "nbtstat -A $host_ip|") or warn "NBTSTAT command failed\n";
  if (NBTSTAT) {
    while (<NBTSTAT>) {
      if (/MAC Address = (.+)/) {
        $nbmac = uc($1);
        chop $nbmac;
        $found = 1;
        print STDERR "found\n" if $verbose;
      } elsif (/\s*(.+)\s+<00>  UNIQUE/) {
        $nbhost = uc($1);
        $nbhost =~ s/[^\w,.-~\$]//g;
      }
    }
  }

  if ($found) { #if NBTSTAT responded
    if ($adcomputer{$nbhost} == 1) {
      print STDERR "\tSkipped NETBios name [$nbhost] in AD\n" if $verbose;
      next;
    } elsif (exists $sccmMac{$nbmac}) {
      print STDERR "\tMAC is $nbmac is in SCCM\n" if $verbose;
      next;
    }
  } else { print STDERR "not found\n" if $verbose; }
}

# update DB


($year, $mon, $mday, $hour, $min) = gettime();
print STDERR "Completed scan at $hour:$min of $mon/$mday/$year\n\n";
