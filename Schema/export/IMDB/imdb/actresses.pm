package imdb::actresses;

use strict;
use warnings;
BEGIN {
	unshift( @INC, "../" );
}


use imdb::actors;
use lib::IMDBUtil;

sub new{
	my $obj = imdb::actors->new();
	$$obj{l} = "ACTRESS";
	return $obj;
}
1;