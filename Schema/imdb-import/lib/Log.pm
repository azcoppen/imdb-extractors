package lib::Log;
use strict;
use warnings;
BEGIN {
	unshift( @INC, "../" );
}

use Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(ERROR INFO DEBUG UNP);

use lib::IMDBUtil;
our $logfile;
our $unpfile;

our $unp;
our $log;

sub init {
	( $logfile, $unpfile ) = @_;
	open $log, ">$logfile";
	open $unp, ">$unpfile";
	my $start_str = logtime()." Started Processing...";
	INFO("-----------------------------------------------------------------------");
	INFO($start_str);
	UNP(0,1,"aa------------------------------------------------------------------------");
	UNP(0,0,$start_str);
}

sub destroy {
	my $start_str = logtime()." finished Processing...";
	INFO($start_str);
	INFO("-----------------------------------------------------------------------");
	UNP(0,0,$start_str);
	UNP(0,1,"------------------------------------------------------------------------");
	close $log;
	close $unp;
}

sub UNP {
	
	my ($file,$line,$msg) = @_;
	die if !defined($msg);
	my $str = ($file && $line?"[$file : $line] ":"").$msg;
	print $unp $msg."\n";
}

sub ERROR {
	unshift (@_,"ERROR");
	pt (@_);
}

sub DEBUG {
	unshift(@_,"DEBUG");
	pt (@_);
}

sub INFO {
	unshift(@_,"INFO");
	pt (@_);
}

sub logtime{
	my @ti = localtime(time);
	return "[".$ti[4]."/".$ti[3]."/".(1900+$ti[5])." $ti[2]:$ti[1]:$ti[0]] "; #MM/DD/YYYY HH24:MI:SS
}

sub pt {
	my ($type,$msg,$file,$line) = @_;
	
	my $str = "[$type] ".logtime().($line?"[$file: $line] ":"").$msg."\n";
	print $log $str;
}
1;
