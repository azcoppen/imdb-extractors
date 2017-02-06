use warnings;

BEGIN {
	unshift( @INC, "../" );
}
use lib::IMDBUtil;

sub test {
	my %ret = lib::IMDBUtil::parse_movie_info(shift,0);
	if (!%ret){
		print 'wtf\n';
	}
	else {
		lib::IMDBUtil::print_r(\%ret);
	}
}

test('"31 Days of Oscar" (1995) {(#12.1)} {{SUSPENDED}}       ????');
1;