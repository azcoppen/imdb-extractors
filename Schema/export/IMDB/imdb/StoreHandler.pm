package imdb::StoreHandler;

use strict;
use warnings;

BEGIN {
	unshift( @INC, "../" );
}

use imdb::RelStore;



use Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(store_actor store_actress store_movie store_genre store_rating store_language);

our $handler;

sub init{
	my $type = shift;
	$handler = $type->new();
}

sub store_actor {
	$handler->store_actor(shift);
}

sub store_actress {
	$handler->store_actress(shift);
}

sub store_movie {
	$handler->store_movie(shift);
}

sub store_genre{
	$handler->store_genre(shift);
}

sub store_language{
	$handler->store_language(shift);
}

sub store_rating{
	$handler->store_rating(shift);
}
1;
