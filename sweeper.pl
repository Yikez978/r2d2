#! /usr/bin/perl
# Written by Eric McCullough
# TODO:
#   use NetPacket::ARP instead of system arp -an
#   thread support?
#   MAC OUI lookup
#   loop every x seconds/minutes/hours
#   ICMP ping option
#   track ack response?
#   syslog output

use strict;
use Net::CIDR::Set;
use Net::Ping;
use JSON;

my ($my_ip, $network_ip, $ip, $mask, $cidr, $gateway, @ips, %arpt);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);

open IFCONFIG, "/sbin/ifconfig eth0|" or die;
while (<IFCONFIG>) {
  chomp;
  if (/inet addr:([\d\.]+)  Bcast:([\d\.]+)  Mask:([\d\.]+)/) {
    $my_ip = $1;
    $mask = $3;
    if ($mask eq "255.255.255.252")    { $cidr = '30'; }
    elsif ($mask eq "255.255.255.248") { $cidr = '29'; }
    elsif ($mask eq "255.255.255.240") { $cidr = '28'; }
    elsif ($mask eq "255.255.255.224") { $cidr = '27'; }
    elsif ($mask eq "255.255.255.192") { $cidr = '26'; }
    elsif ($mask eq "255.255.255.128") { $cidr = '25'; }
    elsif ($mask eq "255.255.255.0")   { $cidr = '24'; }
    elsif ($mask eq "255.255.254.0")   { $cidr = '23'; }
    elsif ($mask eq "255.255.252.0")   { $cidr = '22'; }
    elsif ($mask eq "255.255.248.0")   { $cidr = '21'; }
    elsif ($mask eq "255.255.240.0")   { $cidr = '20'; }
    else { print "failed to convert mask\n"; }
  }
}

open NETSTAT, "/bin/netstat -rn|" or die;
while (<NETSTAT>) {
  if (/^0.0.0.0 +([\d\.]+)/) {
    $gateway = $1;
  }
}

my $set = Net::CIDR::Set->new("$my_ip/$cidr");
if ($gateway eq '') {
  $gateway = 'undefined';
} else {
#  $set->remove("$gateway/32");
}

print STDERR "My IP is $my_ip\nThe mask is $mask which is /$cidr in CIDR notation\nThe gateway is $gateway\n";
$set->remove("$my_ip/32");
my $iter = $set->iterate_addresses;
# make array of IP's mainly so we can remove the network and broadcast IP's
while ( my $ip = $iter->() ) {
  push @ips, $ip;
}

$ip = pop @ips;
print STDERR "Skipping $ip as the broadcast address\n";
$network_ip = shift @ips;
print STDERR "Skipping $ip as the network address\n";

gettime();
print STDERR "Looking for possible rogue hosts at $hour:$min of $mon/$mday/$year\n\n";
my $p = Net::Ping->new("syn", 1); # the second parm is timeout in seconds
$p->{port_number} = 4445; # doesn't matter what port, we just want the ARP response.
foreach my $ip (@ips) {
#  print STDERR "$ip\n";
  $p->ping($ip);
}

while (my ($host,$rtt,$ip) = $p->ack) {
  #print STDERR "HOST: $host [$ip] ACKed port $p->{port_number} in $rtt seconds.\n";
  if (defined $arpt{$ip}) {
    #$arpt{$ip} .= ',ack';
  } else {
    print STDERR "$ip acked but did not have an ARP entry!\n";
    #$arpt{$ip} = 'none,ack';
  }
}
$p->close();

open ARP, "arp -an|";
while (<ARP>) {
  next if /<incomplete>/;
  if (/\(([\d\.]+)\) at ([a-f0-9:]+) /) {
    $arpt{$1} = $2;
  }
}

my $json = '{"sweep":{"description":"' . "$network_ip/$cidr" . '","nodes_attributes":[';
foreach my $ip (keys(%arpt)) {
#  print STDOUT "{ ip: '$ip', mac: '$arpt{$ip}'}\n";
  $json .= '{"ip":"' . $ip . '","mac":"' . $arpt{$ip} . '"},';
}
chop $json; # remove trailing comma
$json .= "]}}";
update_db($json);

gettime();
print STDERR "Completed scan at $hour:$min of $mon/$mday/$year\n\n";

sub gettime {
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  $year += 1900;
  $mon += 1;
  if ($mon < 10) {$mon = "0" . $mon;}
  if ($mday < 10) {$mday = "0" . $mday;}
  if ($hour < 10) {$hour = "0" . $hour;}
  if ($min < 10) {$min = "0" . $min;}
}

sub update_db {
  use LWP::UserAgent;
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
  }
  else {
      print "HTTP POST error code: ", $resp->code, "\n";
      print "HTTP POST error message: ", $resp->message, "\n";
  }
}
