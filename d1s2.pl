# DHCP Server Scanner (d1s2)
# Written by Eric McCullough
# 

use strict;
use JSON;
use Getopt::Long;
use LWP::UserAgent;
use c3p0; # shared subroutines

my $user = "mcculloughs/eric mccullough%p1izzaR2d2!"; # use kerberos?
my ($year, $mon, $mday, $hour, $min);

my @dhcpservers = get_dhcp_servers(); # ('192.168.100.66',); # get from server?
#print "server = $dhcpservers[0]{'ip'}\n";

my %host_list;
my %ip_list;
my %mac_list;
my %reserved_ips;

my $showhelp;
my $result = GetOptions(
  "help|?" => \$showhelp,
  );

if ($showhelp) {
  &showhelp;
}

($year, $mon, $mday, $hour, $min) = &gettime;
&printandpush("Looking for possible rogue hosts at $hour:$min of $mon/$mday/$year\n\n");
my $totalcount = my $foundcount = 0; # for counts of total hosts in dhcp, count of found possible rogue hosts.
my $total_scopes = 0;

foreach my $server_hash (@dhcpservers) {
  my $server = $$server_hash{'ip'};
  my @saved_scopes = get_scopes($$server_hash{'id'}); # from the API
  my %scopes;
  $scopes{'server'}{'scopes_attributes'} = [];
  # get dhcp scopes with description and comments.  Also get reserved IPs and default gateways for each scope.
  my $SCOPES;
  open($SCOPES, "/home/pi/winexe-1.00/source4/bin/winexe -U \"$user\" //$server 'netsh dhcp server \\\\$server dump'|") or warn "Can't get scopes and reserved IPs: $!\n";
  print STDERR "\nLoading scopes and reserved IPs from server at $server\n";
  my $scope_count = 0;
  my $lease_time = my $scope_state = 0;
  my ($scope, $ip, $mask, $desc, $comment);
  my @scope_list;

  while (<$SCOPES>) { # load DHCP scopes
    if (/add scope/) {
      if (defined $ip) {
        $scope = { server => $server, ip => $ip, mask => $mask, description => $desc, comment => $comment, leasetime => $lease_time, state => $scope_state };
        push $scopes{'server'}{'scopes_attributes'}, $scope;
      }
      $lease_time = $scope_state = 0;
      ($ip, $mask, $desc, $comment) = /.+scope ([\d\.]+) ([\d\.]+).+"(.*)" "(.*)"/;
    } elsif (/set state (\d)/) {
      $scope_state = $1;
      if ($scope_state eq '1') { # 1 == active scope
        push @scope_list, $ip;
        $scope_count += 1;
      } else { print STDERR "Skipping inactive scope $ip\t$desc\t$comment\n"; }
    } elsif ($scope_state eq '1') {
      #Dhcp Server 14.15.19.14 Scope 14.15.42.0 Add reservedip 14.15.42.101 001577a08c0c "WD0800493.odd.com" "for firewall rules" "BOTH"
      if (/Add reservedip ([\d\.]+) ([\w]+) "(.*)"/) {
        my $ip = $1;
        my $mac = uc($2);
        $mac =~ /([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})/;
        $reserved_ips{$ip} = "$1-$2-$3-$4-$5-$6";
      } elsif (/optionvalue 3 IPADDRESS "([\d\.]+)"/) {
        $reserved_ips{$1} = "Default Gateway";
      } elsif (/optionvalue 51 DWORD "(\d+)"/) { # lease duration in seconds
        $lease_time = $1;
      }
    }
  }
  if (defined $ip) {
    $scope = { server => $server, ip => $ip, mask => $mask, description => $desc, comment => $comment, leasetime => $lease_time, state => $scope_state };
    push $scopes{'server'}{'scopes_attributes'}, $scope;
  }
  print STDERR "Number of active scopes loaded from $server is $scope_count\n\n";
  my $json = encode_json \%scopes;
  print STDERR "$json\n"; ############## update server here ##################
  $total_scopes += $scope_count;
  close $SCOPES;

  my $goodline = 0;
  foreach my $scope (@scope_list) {
    print STDERR "Searching $scope...\n";
    open (DHCPCMD, "/home/pi/winexe-1.00/source4/bin/winexe -U \"$user\" //$server 'netsh dhcp server \\\\$server scope $scope show clients 1'|") or
      die "winexe //$server 'netsh dhcp server $server scope $scope show clients 1' command failed";
    while (<DHCPCMD>) {
      my $dhcphost = my $ip = my $lease = my $dhcpmac = my $type = $mask = "";
      if (/The command needs a valid Scope IP Address/) {
        print STDERR "winexe -U $user //$server netsh failed to read scopes from $server, running under priviledged account?\n";
      } elsif (/^\d{1,3}/) {
        $goodline = 0;
        $totalcount += 1;
        # each record has the following format
        # IP Address      - Subnet Mask    - Unique ID           - Lease Expires        -Type -Name
        # 14.15.14.12  - 255.255.252.0  - 00-1a-4b-18-02-8a   -5/9/2010 9:20:44 AM    -D-  P-3D1053.com
        if ( ($ip, $mask, $dhcpmac, $lease, $type, $dhcphost)  # has normal lease date/time
            = /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*- (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*-\s*(.{17})\s*-\s*([0-9\/]+\s*[\d:]+\s*[AP]M)\s*-([DBURN])-\s*(.+)/ ) {
          $goodline = 1;
        } elsif ( ($ip, $mask, $dhcpmac, $lease, $type, $dhcphost) # has NEVER EXPIRES, INACTIVE, in lease field
            = /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*- (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*-\s*(.{17})\s*-\s*([\s\w]+)\s*-([DBURN])-\s*(.+)/ ) {
          while ($lease =~ s/\s$//g) {}
          $goodline = 1;
        }
        if ($goodline) {
          $dhcpmac = uc($dhcpmac); # upper case the letters in the MAC
          $dhcpmac =~ s/ //g; # remove spaces from the MAC
          $dhcphost =~ s/\.$//; # remove trailing '.' from host name
          $dhcphost =~ s/\s//g; # remove spaces from host name
          $dhcphost = uc($dhcphost);
          $dhcphost =~ /([\w\-\_]+)\.*/;

          $foundcount += 1;
          $host_list{$dhcphost} += 1;
          $ip_list{$ip} += 1;
          $mac_list{$dhcpmac} += 1;

          #update server or save to bulk load?
          #print $OUTPUT "\"$dhcpmac\",\"$mon/$mday/$year\",\"$dhcphost\",\"$scopedesc\",\"$ip\",\"$lease\",\"$vendor\",\"$nbmac\",\"$nbhost\",\"$alive\",\"$encase\",\"$cshare\",\"$sav\",\"$epo\",\"$port80\",\"$server\",\"$sccm\"\n";
        }
      }
    }
  }
  undef @scope_list;
}

my $count = @dhcpservers;
print STDERR "Found $foundcount host(s) out of a total of $totalcount listed in the $total_scopes DHCP scopes on $count server(s).\n";

print STDERR "\n";
foreach my $host (keys %host_list) {
  if ($host_list{$host} > 1) { print STDERR "\"$host\" is a duplicate host name which occurs $host_list{$host} times\n"; }
}

print STDERR "\n";
foreach my $ip (keys %ip_list) {
  print STDERR "$ip is a duplicate ip address\n" if $ip_list{$ip} > 1;
}

print STDERR "\n";
foreach my $mac (keys %mac_list) {
  print STDERR "$mac is a duplicate MAC address\n" if $mac_list{$mac} > 1;
}

($year, $mon, $mday, $hour, $min) = &gettime;
print STDERR "Completed at $hour:$min of $mon/$mday/$year\n";

##########################
# Subroutines
##########################

sub showhelp {
  print STDERR <<THERE ;

           DHCP Server Scanner
Reads DHCP server to feed the Remote Rogue Device Detector.

To run without options, from a command prompt enter:
d1s2.pl

Options:
  --help     print this help and exit

THERE
  exit;
}

sub get_dhcp_servers {
  my $ua = LWP::UserAgent->new;
  my $server_endpoint = "http://api.r2d2.com:3000/api/servers";
  my $req = HTTP::Request->new(GET => $server_endpoint);
  $req->header('content-type' => 'application/json');
  $req->header('Accept' => 'application/json');
  my $resp = $ua->request($req);
  if ($resp->is_success) {
      my $message = $resp->decoded_content;
      print "get_dhcp_servers received reply: $message\n";
  } else {
      print "HTTP GET error code: ", $resp->code, "\n";
      print "HTTP GET error message: ", $resp->message, "\n";
  }
  my @array = decode_json($resp->decoded_content);
  return $array[0][0];
}

sub get_scopes {
  my $server_id = shift;
  my $ua = LWP::UserAgent->new;
  my $server_endpoint = "http://api.r2d2.com:3000/api/servers/$server_id";
  my $req = HTTP::Request->new(GET => $server_endpoint);
  $req->header('content-type' => 'application/json');
  $req->header('Accept' => 'application/json');
  my $resp = $ua->request($req);
  if ($resp->is_success) {
      my $message = $resp->decoded_content;
      print "get scopes received reply: $message\n";
  } else {
      print "HTTP GET error code: ", $resp->code, "\n";
      print "HTTP GET error message: ", $resp->message, "\n";
  }
  my @array = decode_json($resp->decoded_content);
  return $array[0][0];
}

sub update_db {
  my $json = shift;
  my $ua = LWP::UserAgent->new;
  my $server_endpoint = "http://api.r2d2.com:3000/api/sweeps";
  #my $server_endpoint = "https://api.strong-stone-3754.herokuapp.com/sweeps"; # does this work?

  # set custom HTTP request header fields
  my $req = HTTP::Request->new(POST => $server_endpoint);
  $req->header('content-type' => 'application/json');
  $req->header('Accept' => 'application/json');
  
  # add POST data to HTTP request body
  my $post_data = $json;
  $req->content($post_data);
  
  my $resp = $ua->request($req);
  if ($resp->is_success) {
      my $message = $resp->decoded_content;
      print "Received reply: $message\n";
  } else {
      print "HTTP POST error code: ", $resp->code, "\n";
      print "HTTP POST error message: ", $resp->message, "\n";
  }
}
