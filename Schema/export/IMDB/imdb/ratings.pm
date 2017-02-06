package imdb::ratings;
use strict;
use warnings;

BEGIN {
	unshift( @INC, "../" );
}

use lib::IMDBUtil;
use imdb::StoreHandler;
use lib::db;
use imdb::cache;

our $begun = 0;

sub new {
	my $class = shift;
	my $obj = { context => undef };
	bless $obj, $class;
	return $obj;
}

sub is_store_ready {
	shift;
	my $r = shift;
	if ($r){
		return 1;
	}
	return 0;
}

sub parse {
	shift;
	my $line = shift;
	my $lid = shift;
	
	# TODO skip to the part where ratings begin;
	my ($distribution,$num_votes,$rating,$rest);
	if ($line =~ m/\s+([\w.*]+)\s/gc){
		$distribution = t($1);
	}
	if ($line =~ m/\G\s+\b([\d]+)\b/gc){
		$num_votes = t($1);
	}
	if ($line =~ m/\G\s+\b([\d.]+)\b/gc){
		$rating = t($1);
	}
	
	if ($line =~ m/\G(.+)/gc){
		$rest = t($1);
	}
	my %ret = lib::IMDBUtil::parse_movie_info($rest);
	if ($ret{type}){
		$ret{distribution} = $distribution;
		$ret{num_votes} = $num_votes;
		$ret{rating} = $rating;
	}
	return %ret;	
}

sub store {
	shift;
	my $r = shift;
	store_rating($r);
}


sub set_context {

}

# debugging helper methods, to be deleted once everything is finished.
sub how_many_lines {
	return -1;
}

sub print_info {
}
1;