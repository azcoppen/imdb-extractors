use warnings;

BEGIN {
	unshift( @INC, "../" );
}
use lib::IMDBUtil;

sub test_assign {
	my ( $a, $b, $c ) = ( "a", "", " " );
	if ($a) {
		print "a \n";
	}
	if ($b) {
		print "b \n";
	}
	if ($c) {
		print "c \n";
	}
}

sub test_array {
	my @arr;
	my %hash = ( a => "a", b => "b", c => \@arr );

	push( @{ $hash{c} }, 'c' );

	push( @arr, 'j' );

	push( @arr, "" );
	my @a2 = ( "a", "b", "c" );
	my %h2 = ( a1 => "a1", a2 => \@a2 );

	push( @{ $hash{c} }, \%h2 );

	print_r( \%hash );

	return %hash;

}

sub test_pass_ref {

	my $ref = shift;
	print $ref, "\n";
	if ( ref($ref) eq 'HASH' ) {
		my %hash = %$ref;
		foreach my $k ( keys %hash ) {
			print $k, " => ", $hash{$k}, "\n";
		}
	}
}

sub test_oper {
	my $i = 100;
	if ( $i % 11 == 0 ) {
		print "aha";
	}
}

sub test_ml {
	my $a = 1;
	my $b = ( $a == 1 ? "0" : "1" );
	print $b;

}

sub test_shift {
	my @arr = ( 'a', 'b', 'c' );
	print_r( \@arr );
	print shift @arr, "\n";
	print_r( \@arr );
	print shift @arr, "\n";
	print_r( \@arr );
	print shift @arr, "\n";
	print_r( \@arr );
	my ( $a, $b ) = @arr;

	if ( $a && $a eq 'd' ) {
		print "\n\n hhhhh";
	}

}

sub test_case {
	my $l = "8: THE GENRES LiST";
	if ( $l =~ m/THE GENRES LIST/ ) {
		print "aaargh";
	}
}

sub test_wb {
	my $line =
"      ....001213      52   8.2  \"Avatar: The Last Airbender\" (2005) {Appa's Lost Days (#2.16)}";

	my ( $distribution, $num_votes, $rating, $rest );
	if ( $line =~ m/\s+([\w.]+)\s/gc ) {
		$distribution = t($1);
	}
	if ( $line =~ m/\G\s+\b([\d]+)\b/gc ) {
		$num_votes = t($1);
	}
	if ( $line =~ m/\G\s+\b([\d.]+)\b/gc ) {
		$rating = t($1);
	}

	if ( $line =~ m/\G(.+)/gc ) {
		$rest = t($1);
	}
	my %ret = lib::IMDBUtil::parse_movie_info($rest);
	if ( $ret{type} ) {
		$ret{distribution} = $distribution;
		$ret{num_votes}    = $num_votes;
		$ret{rating}       = $rating;
	}
	print_r( \%ret );

}

sub test_actor {
	my $line1 =
	  "Stuck in the Middle (2003) (V)  (archive footage)  [Themselves] <20>";
	my $line2 = "\"'Allo 'Allo!\" (1982) {A Bun in the Oven (#8.0)}	English";
	my $line3 = "\"Rock Concert\" (1973) {(#3.21)}  [Themselves]";

	my %movie = lib::IMDBUtil::parse_movie_info($line2);

	return %movie;

}

sub test_push {
	my @arr = ("here");
	unshift( @arr, "now" );
	foreach my $m (@arr) {
		print $m . "\n";
	}
}
test_push;
