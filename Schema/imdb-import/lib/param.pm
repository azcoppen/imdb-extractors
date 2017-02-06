package lib::param;

use strict;
use warnings;

BEGIN {
	unshift( @INC, "../" );
}
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT =
  qw (get_param DATABASE_URL DATABASE_USER DATABASE_PWD DATABASE_HANDLER IMPORT_LIST LOGFILE FOLDER UNP_FILE HAS_MOVIE STORE_HANDLER SHOULD_CLEAR_DATABASE);

use constant DATABASE_URL     => "database.url";
use constant DATABASE_USER    => "database.user";
use constant DATABASE_PWD     => "database.pwd";
use constant DATABASE_HANDLER => "database.handler";
use constant IMPORT_LIST      => "import.list";
use constant LOGFILE          => "log.logfile";
use constant UNP_FILE         => "log.unprocessed";
use constant FOLDER           => "data.folder";
use constant HAS_MOVIE        => "has.movie";
use constant STORE_HANDLER    => "database.storageHandler";
use constant SHOULD_CLEAR_DATABASE    => "database.should_clear";

use lib::file( 'open_file', 'close_file', 'next_line' );
use lib::IMDBUtil;

our %hash;

sub init {
	open_file(shift);
	my @a;
	my $hasmovie = 0;
	while ( my $line = next_line() ) {
		chomp($line);
		$line = t($line);
		if ( $line && $line =~ m/([\w.]+)=([^#]+)(\s+\#(.+))?/ ) {
			my $k = t($1);
			my $v = t($2);

			if ( $k =~ m/import\.(.+)/ ) {
				if ( $v == 1 ) {
					push( @a, $1 );
					if ( $1 eq "movies" ) {
						$hasmovie = 1;
					}
				}

			}
			else {
				$hash{$k} = $v;
			}
		}
	}

	$hash{"import.list"} = \@a;
	$hash{"has.movie"}   = $hasmovie;

	print " Parameters: ";
	print_r(\%hash);
	print "\n";
	close_file();
}

sub get_param {
	my $p = shift;
	return $hash{$p};
}

sub test {
	init("../import.params");
	my $il = get_param(IMPORT_LIST);

	foreach my $imp (@$il) {
		print $imp, "\n";
	}
	
	print get_param(HAS_MOVIE),"\n";

}
1;
