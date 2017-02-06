package imdb::cache;

use strict;
use warnings;

BEGIN {
	unshift( @INC, "../" );

}

use Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(add get);
use lib::IMDBUtil;

use constant NOT_PRESENT => 0;
use Switch;
our %movies; # {year}{year_suffix}{title}
our %shows;  # {year}{year_suffix}{title}
our %language;
our %genre;
our %episodes;    #{sid}{episode title}{season}{episode#}
our %actors; # {gender}fullname}

# Implementation of a two level cache. Just holds movies and show titles indexed by year
# Used to lookup FK values for shows and movies.
# If year is not defined, use 1111 as key.
sub add {
	
	
	my $ref = shift;
	my $id  = shift;
	
	if (!$$ref{type}){
		return;
	}

	switch ( $$ref{type} ) {
		case "movie" {
			my $y = $$ref{year};
			if ( !$y ) {
				$y = "1111";
			}
			my $ys = $$ref{year_suffix};
			if (!$ys){
				$ys = 'I';
			}
			$movies{$y}{$ys}{$$ref{title} } = $id;

		}
		case "show" {
			my $y = $$ref{year};
			if ( !$y ) {
				$y = "1111";
			}
			my $ys = $$ref{year_suffix};
			if (!$ys){
				$ys = 'I';
			}
			$shows{$y}{$ys}{$$ref{title} } = $id;

		}
		case "episode" {
			my ( $sid, $t, $s, $e ) =
			  ( $$ref{sid}, $$ref{title}, $$ref{season}, $$ref{episode_no} );
			if ( !$s ) {
				$s = 1;
			}
			if (!$e){
				$e =1;
			}
			$episodes{$sid}{$t}{$s}{$e} = $id;
		}
		case "genre" {
			$genre{ $$ref{genre} } = $id;
		}
		case "language" {
			$language{ $$ref{language} } = $id;
		}
		case "actor" {
			$actors{$$ref{gender}}{$$ref{fullname}} = $id;
		}
		else {
			print "what are we adding here? \n"
		}
	}
}

sub load {

	# Load language
	my $lang_stm = lib::db::execute_sql("select id,name from language");
	while ( my @r = $lang_stm->fetchrow_array ) {
		$language{ $r[1] } = $r[0];
	}

	# Load Genre
	my $genre_stm = lib::db::execute_sql("select id,name from genre");
	while ( my @r = $genre_stm->fetchrow_array ) {
		$genre{ $r[1] } = $r[0];
	}

	# Load movie
	my $movie_stm = lib::db::execute_sql("select mid,title,year,year_suffix from movies");
	while ( my @r = $movie_stm->fetchrow_array ) {
		my $y = $r[2];
		if (!$y){
			$y = "1111";
		}
		my $ys = $r[3];
			if (!$ys){
				$ys = 'I';
			}
		$movies{ $y}{$ys}{$r[1]} = $r[0];
	}

	# Load episode
	my $show_stm = lib::db::execute_sql("select sid,title,year,year_suffix from shows");
	while ( my @r = $show_stm->fetchrow_array ) {
		my $y = $r[2];
		if (!$y){
			$y = "1111";
		}
		my $ys = $r[3];
			if (!$ys){
				$ys = 'I';
			}
		$shows{ $y}{$ys}{$r[1] }= $r[0];
	}
	
	my $show_ep = lib::db::execute_sql("select eid,sid,title,season,episode_no from show_episodes");
	while ( my @r = $show_ep->fetchrow_array ) {
		
		my ($sid,$t,$s,$e) = ($r[1],$r[2],($r[3]?$r[3]:1),($r[4]?$r[4]:1));
				
		$episodes{$sid}{$t}{$s}{$e} = $r[0];
	}
	
	
}

sub get_language {
	my ($l) = @_;
	my $id = $language{$l};
	
	return $id;
}

sub get_genre {
	my ($l) = @_;
	my $id = $genre{$l};
	return $id;
}

sub get_movie {
	my ( $m, $y ,$ys) = @_;
	if ( !$y ) {
		$y = "1111";
	}
	if(!$ys){
		$ys ='I';
	}
	return $movies{$y}{$ys}{$m};
}

sub get_show {
	my ( $m, $y,$ys ) = @_;
	if ( !$y ) {
		$y = "1111";
	}
	if(!$ys){
		$ys ='I';
	}
	return $shows{$y}{$ys}{$m};
}

sub get_episode {
	my ( $sid, $t, $s, $e ) = @_;
	if ( !$s ) {
		$s = 1;
	}
	if (!$e){
		$e =1;
	}
	my $id = $episodes{$sid}{$t}{$s}{$e};
	if ( !$id ) {
		$id = NOT_PRESENT;
	}
	return $id;
}

sub get_actor {
	my ($fullname,$gender) = @_;
	return $actors{$gender}{$fullname};
	
}
1;
