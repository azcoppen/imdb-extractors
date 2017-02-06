use strict;
use warnings;

BEGIN {
	unshift( @INC, "." );
}
use lib::processor( "init", "process", "destroy" );
use lib::param;

#imports for imdb handlers.
use imdb::actors;
use imdb::actresses;
use imdb::movies;
use imdb::cache;
use imdb::ratings;
use imdb::genres; 
use imdb::language;

sub process_main {
	
	my $param_file = shift;
	
	if (!$param_file){
		$param_file = "import.params";
	}

	lib::param::init($param_file);

	# TODO :- fail gracefully if all required options are not provided.

	lib::processor::init( get_param(DATABASE_URL), get_param(DATABASE_USER),
		get_param(DATABASE_PWD) );
	
	my $imports = get_param(IMPORT_LIST);

	foreach my $imp (@$imports) {
		my $file = get_param(FOLDER) . "$imp.list";
		lib::processor::process( $file, $imp, "imdb::$imp"->new() );
	}

	lib::processor::destroy();

}

process_main @ARGV;
1;

