package lib::file;

use strict;
use warnings;
use Exporter;
our @ISA = ('Exporter');
our @EXPORT_OK=( 'open_file', 'close_file', 'next_line' );

our $ffile;
our $fname;
our $is_open = 0;

sub open_file {
	$fname = shift;
	open $ffile, $fname or die "file $fname not present";
	$is_open = 1;
}

sub close_file {
	if ( $is_open == 0 ){
		return;
	}
	close $ffile;
	$is_open = 0;
}

sub next_line {
	die "No file opened" if ( $is_open == 0 );
	my $line = <$ffile>;
	if ( !$line ) {
		close_file;
	}
	return $line;

}
1;

