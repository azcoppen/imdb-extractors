package imdb::actors;

use strict;
use warnings;
BEGIN {
	unshift( @INC, "../" );
	
}

use lib::IMDBUtil;
use imdb::StoreHandler;
our %actor;
#our $is_store = 0;

# keep an indicator for last two lines.
# to detect begin of a parse.
our $line1 = "";
our $line2 = "";

#delete me later
my $i = 0;
my $u = 0;

sub new {

	# dummy object
	my $obj = { "l" => "ACTOR"};
	bless $obj, shift;
	return $obj;
}

sub is_parse_ready {

	my @line_fragments = split( /\t+/, $line1 );
	if ( ( my $size = @line_fragments ) != 2 ) {
		return 0;
	}
	if (   trim( $line_fragments[0] ) eq 'Name'
		&& trim( $line_fragments[1] ) eq 'Titles' )
	{
		return 1;
	}
	return 0;
}

sub is_store_ready {
	shift;
	my $o = shift;
	return $o;
}

sub parse {
	my $class = shift;
	my $line = shift;
	my $line_id = shift;

	my %ret;

	if ( !is_parse_ready() ) {
		$line1 = $line2;
		$line2 = $line;
		return %ret;
	}
	

	my @frgs = split( /\t+/, $line );
	my $character_part;
	my $actor_str = "";
	if ( ( my $size = @frgs ) == 2 ) {
		$character_part = $frgs[1];
		$actor_str      = $frgs[0];
	}

	#parse the actor and store 'it'
	my @actornames = split( /,/, $actor_str );
	if ( scalar @actornames == 2 ) {
		%actor = (
			fullname => trim($actor_str),
			fname    => trim( $actornames[1] ),
			lname    => trim( $actornames[0] )
		);
		
		$actor{type} = "actor";
		
		if ($$class{l} eq "ACTOR"){
			$actor{gender}= 'M';
		}
		else {
			$actor{gender}= 'F';
		}
	}
	
	

	#parse the credit and store it in @credits array;
	$i++;
	if ($character_part) {
		$character_part = trim($character_part);
		my %movie = lib::IMDBUtil::parse_movie_info($character_part);
		my $rest = t($movie{unused});
		
		my $p =0;
		
		if ($rest){
			if ($rest =~ m/^\((.*?)\)/gc){
				$movie{notes} =$1;
				$p=1;
			}
			if ($rest =~ m/\G\s*\[(.+)\]/gc){
				$movie{role}=$1;
				$p=1;
			}
			if ($rest =~ m/<(.+)>/){
				$movie{credit_no} = $1;
				$p=1;
			}
		}
		  	
		if ($rest && !$p) {
			debug($rest,$line_id);
		}
		$ret{type} = "actorfull";
		$ret{role} = \%movie;
		$ret{actor}=\%actor;
	}
	
	
	return %ret;

}

sub store {
	shift;
	# reset state
	store_actor(shift);
	
}

sub set_context {
}

# debugging helper methods, to be deleted once everything is finished.
sub how_many_lines {
	return -1;
}

sub print_info {
	print "processed: $i, unprocessed: $u \n";
}
1;
