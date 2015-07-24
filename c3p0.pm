# c3p0.pm
# shared functions for r2d2.pl, etc.

sub getMAClist {
  $filename = shift; # input file = whitelist.txt | blacklist.txt (so far)
  $hashref = shift; # Where the results are stored
  $commentflag = shift; # keep comments or not.  0 = don't keep, 1 = keep. Whitelist doesn't need comments ATM.  Blacklist uses them in the Summary.txt
  if (open ($FILE, "<", $filename)) {
    print STDERR "Loading $filename\n";
    $count = 0;
    while (<$FILE>) {
      $count += 1;
      if (($mac, $comment) = /^([\da-fA-F]{2}-[\da-fA-F]{2}-[\da-fA-F]{2}-[\da-fA-F]{2}-[\da-fA-F]{2}-[\da-fA-F]{2})(.*)$/) {
        $mac = uc($mac);
        if ( $commentflag ) { $$hashref{$mac} = $comment; }
        else { $$hashref{$mac} = undef; }
      }
      else { print STDERR "$filename line $count is in wrong format\n$_\n"; }
    }
    &printandpush("$filename contains $count entries.\n");
  } else { &printandpush("Unable to open $filename: $!\n"); }
  close $FILE;
}

sub getADnames {
  # get computer names from AD
  my $dcs = shift;
  $hashref = shift;
  foreach $dc (keys(%$dcs)) {
    open (DSQUERY, "dsquery.exe * ".$$dcs->$dc." -s $dc -filter \"(&(samaccounttype=805306369))\" -limit 0|")
      or warn "Unable to get computer names from $dc\n";
    if (DSQUERY) {
      print STDERR "Loading Computer names from $dc\nNames not loaded will be displayed\n";
      $count = 0;
      while (<DSQUERY>) {
        if (/\"CN=([\w\-]+),/) {
          $$hashref{uc($1)} = 1;
          $count += 1;
        } else { print STDERR $_; }
      }
      close DSQUERY;
      &printandpush("Number of computer names loaded from $dc is $count\n");
    }
    # get printer names from AD
    open (DSQUERY, "dsquery.exe * ".$$dcs->$dc." -s $dc -filter \"(&(objectClass=PrintQueue))\" -limit 0 -attr PrinterName|")
      || warn "Unable to get printer names from $dc\n";
    if (DSQUERY) {
      print STDERR "Loading Printer names from $dc\nNames not loaded will be displayed\n";
      $count = 0;
      while (<DSQUERY>) {
        while (s/\s$//g) {}
        if (/\s+([\w\-\ ]+)/) {
          $$hashref{uc($1)} += 1;
          if ($$hashref{uc($1)} > 1) { print STDERR "Duplicate printer: $1\n"; }
          $count += 1; # change this to only count unique printer names?
        } else { print STDERR $_; }
      }
      close DSQUERY;
      &printandpush("Number of printer names loaded from $dc is $count\n");
    }
  }
}

sub printandpush { #### replace with TEE
  my $string = shift;
  print STDERR $string;
  push @notable, $string;
}

sub pingport {
  use Net::Ping;

  $port = shift;
  undef $result;
  unless ($port > 0 && $port < 65546) {
    print STDERR "Bad port specified for ping test: $port\n";
  } else {
    $p = Net::Ping->new("syn",2);
    $p->port_number($port);
    $p->ping($ip);
    while (($host,$rtt,$fip) = $p->ack) {
      print "HOST: $dnsname [$ip] ACKed port $port in $rtt seconds.\n" if $verbose;
      $result = 'Y';
    }
    $p->close();
  }
  return $result;
}

sub pinghost {
  use Net::Ping;

  my $ip = shift; # check IP format
  my $count = shift; # check count exists & int & < some number
  my $alive = 'N';
  my $p = Net::Ping->new("icmp",1);
  for ($i = 1; $i <= $count; $i++) {
    if ($p->ping($ip)) {
      $alive = "Y";
      last;
    }
  }
  $p->close();
  return $alive;
}

sub gettime {
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  $year += 1900;
  $mon += 1;
  if ($mon < 10) { $mon = "0" . $mon; }
  if ($mday < 10) { $mday = "0" . $mday; }
  if ($hour < 10) { $hour = "0" . $hour; }
  if ($min < 10) { $min = "0" . $min; }
}

sub loadVendorCodes {
  # vendor.txt is for identifying the OUI of the MAC
  if (open (VENDOR, "vendor.txt")) {
    print STDERR "Loading vendor codes\n";
    $count = 0;
    while (<VENDOR>) {
      chomp(($vendor, $desc) = split(/\,/,$_,2));
      $vendor{$vendor} = $desc;
      $count += 1;
    }
    &printandpush("Loaded $count vendor codes\n");
  } else { &printandpush("Failed to load the vendor codes\n"); }
  close VENDOR;
}

sub getvendor {
  my $mac = shift;

  if (length($mac) eq 17) {
    $mac = uc $mac;
    $mac =~ s/\.//;
    ($vendor, undef) = substr $mac,0,8;
    if (exists $vendor{$vendor}) { return $vendor{$vendor}; }
    else { return "UNKNOWN"; }
  } else {
		return "INVALID OUI";
	}
}

sub updatevendorlist {
  use LWP::Simple;
  $content = get("http://standards.ieee.org/regauth/oui/oui.txt");
    die "Couldn't get it!" unless defined $content;
  @lines = split /\n/,$content;
  if (-e "vendor.txt") {
    if (-e "vendor.old") { unlink "vendor.old"; }
    system "ren vendor.txt vendor.old";
  }
  open (OUT, ">vendor.txt") or die;
  foreach $line (@lines) {
    next unless $line =~ /\(hex/;
    ($oui, $vendor) = split /   \(hex\)\t\t/,$line;
    print OUT "$oui,$vendor\n";
  }
}

1;