package imdb::movies;
use strict;
use warnings;
use constant MOVIE => 'movie';
use constant SHOW  => 'show';

BEGIN {
	unshift( @INC, "../" );
}
use imdb::StoreHandler;
use lib::IMDBUtil;
use lib::db;
use imdb::cache;
use lib::Log;

our $s   = 0;
our $idx = 0;

our $begun = 0;

sub new {
	my $class = shift;
	my $obj = { context => undef };
	bless $obj, $class;
	return $obj;
}

sub is_store_ready {
	return $begun;
}

sub parse {

	shift;
	my $line      = shift;
	my $line_id   = shift;
	my @line_frgs = split( /\t+/, $line );

	my %ret;
	if ( $#line_frgs + 1 >= 1 ) {
		%ret = lib::IMDBUtil::parse_movie_info( shift @line_frgs, $line_id );
		if ( $ret{type} ) {
			$begun = 1;
			if ( $ret{type} eq MOVIE ) {
				my $year_part = shift @line_frgs;
				my $year_end  = "";
				my $year_start;
				if (   $year_part
					&& $year_part =~ m/\s+([\d|?]{4})(-([\d|?]{4}))?/gc )
				{
					$year_start = t($1);

					if ( !$2 ) {
						$year_end = t($2);
					}
				}

				my $notes_part = shift @line_frgs;
				my $notes;
				if ( $notes_part && $notes_part =~ m/\s+\((.+)\)/ ) {
					$notes = t($1);
				}

				if (   $year_start
					&& $year_start ne '????'
					&& $ret{year} eq '????' )
				{
					$ret{year} = $year_start;
				}
				$ret{year_end} =
				  ( $year_end && $year_end ne "????" ? $year_end : "" );
				$ret{notes} = $notes;

			}
			else {

				my ( $ep_times, $notes );
				my ( $ep_times_part, $notes_part ) = @line_frgs;

				if (   $ep_times_part
					&& $ep_times_part =~ m/\s+([\d|?]{4}(-[\d|?]{4})?[,]?)+/gc )
				{
					$ep_times = t($1);

				}
				if ( $notes_part && $notes_part =~ m/\s+\((.+)\)/cg ) {
					$notes = t($1);
				}

				my $episode_hash = $ret{episode};
				if ($episode_hash) {
					$$episode_hash{years} = $ep_times;
					$$episode_hash{notes} = $notes;
				}

			}
		}
		else {
			$begun = 0;
			UNP("movies.list",$line_id,$line);
		}
	}

	return %ret;
}

sub store {
	shift;
	my $m = shift;
	store_movie($m);
	
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
