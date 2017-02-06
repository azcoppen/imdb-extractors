package lib::IMDBUtil;
use strict;
use warnings;

# Functions 'trim', 'ltrim' & 'rtrim' copied from http://www.somacon.com/p114.php
use Exporter;
our @ISA = ('Exporter');
our @EXPORT = ( 'trim', 'ltrim', 'rtrim', 'debug', 't', 'print_r', );
use constant DEBUG => 1;

sub t {
	return trim(shift);
}

# Perl trim function to remove whitespace from the start and end of the string
sub trim {
	my $string = shift;
	if ( !$string ) {
		return $string;
	}
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

# Left trim function to remove leading whitespace
sub ltrim {
	my $string = shift;
	if ( !$string ) {
		return $string;
	}
	$string =~ s/^\s+//;
	return $string;
}

# Right trim function to remove trailing whitespace
sub rtrim {
	my $string = shift;
	if ( !$string ) {
		return $string;
	}
	$string =~ s/\s+$//;
	return $string;
}

# debug method. Just dump on the screen
sub debug {
	if ( !DEBUG ) {
		return;
	}
	my ( $line, $lid ) = @_;

	print "", ( $lid ? $lid . " :- " : "" ), $line, "\n";
}

# Perl equivalent of PHP print_r function
sub print_r{
	print_r_internal(@_);
	print "\n";
}

sub print_r_internal {
	use Switch;
	my $ref   = shift;
	my $level = shift;

	sub pr_level {
		print "  " x shift, shift;
	}

	if ( !defined($level) ) {
		$level = 0;
	}

	my $type = ref($ref);
	if ( !$type ) {
		$type = "VAL";
	}

	if ( !$ref ) {
		$type = "UNDEF";
	}

	switch ($type) {
		case "UNDEF" {
			print "undef";
		}
		case "HASH" {
			pr_level( 0,      "HASH\n" );
			pr_level( $level, "(\n" );
			$level++;
			foreach my $k ( sort keys %$ref ) {
				pr_level( $level, "[$k] => " );
				print_r( $$ref{$k}, $level + 1 );
				print "\n";
			}
			$level--;
			pr_level( $level, ")" );

		}
		case "ARRAY" {
			pr_level( 0,      "ARRAY\n" );
			pr_level( $level, "(\n" );
			$level++;
			my $i = 0;
			foreach my $k (@$ref) {
				pr_level( $level, "[$i] => " );
				print_r( $k, $level + 1 );
				print "\n";
				$i++;
			}
			$level--;
			pr_level( $level, ")" );

		}
		case "SCALAR" {
			print scalar $$ref;
		}
		case "VAL" {
			if ($ref) {
				print $ref;
			}
		}

		else {
			print "not handled: ", $type, "---> ", $ref, "\n";
		}
	}
}

sub parse_movie_info{
	my $line    = shift;
	my $line_id = shift;
	my %ret;
	my $unused;
	if ( $line !~ m/^["]/ ) {
		
		if ( $line =~ m/^(.*?)\(([\d|?]{4})(\/([IVX]{1,5}))?\)/g ) {
			my ( $title, $year_start, $tv, $suspended ,$year_suffix);
			$title      = t($1);
			$year_start = t($2);
			$year_suffix  = t($4);
			$suspended  = 0;
			$tv         = "";

			if ( $line =~ m/\G\s+\(([TVG]{1,2})\)/gc ) {

				#	print " ($1) "
				$tv = t($1);

			}
			if ( $line =~ m/\G\s+\{\{(SUSPENDE[D]?|SUSPENSION)\}\}/gc ) {

				#	print " [suspended] ";
				$suspended = 1;
			}

			if ( $line =~ m/\G(.+)/gc ) {
				my $rep = trim($1);
				if ( $rep ne "" ) {
					$unused = $rep;
				}

			}
			if ($title) {
				$ret{type}  = "movie";
				$ret{title} = $title;
				$ret{year} =
				  ( $year_start && $year_start ne "????" ? $year_start : "0" );
				$ret{vtype}     = $tv;
				$ret{suspended} = $suspended;
				$ret{year_suffix}= $year_suffix;
			}
		}

	}
	elsif ( $line =~
		m/^\"(.*?)\"\s+\(([\d|?]{4})(\/([IVX]{1,5}))?\)(\s+(\{([^{]+)\}))?/g )
	{
		my ( $show, $year, $episode, $notes, $ep_times, $ep_season, $ep_num,$year_suffix,
			$suspended );
		$show    = t($1);
		$year    = $2;
		$year_suffix = t($4);
		$episode = t($7);
		if ($episode) {
			if ( $episode =~ m/(.+)?\(\#(\d+)\.(\d+)\)/ ) {
				if ( t($1) ) {
					$episode = t($1);
				}
				$ep_season = t($2);
				$ep_num    = t($3);
			}

		}

		if ( $line =~ m/\G\s+\{\{(SUSPENDE[D]?|SUSPENSION)\}\}/gc ) {

			#	print " [suspended] ";
			$suspended = 1;
		}

		if ( $line =~ m/\G(.+)/gc ) {
			my $rep = trim($1);
			if ( $rep ne "" ) {
				$unused = $rep;
			}
		}

		#my $show_ref = $shows{$show};
		$ret{type}  = "show";
		$ret{title} = $show;
		$ret{year_suffix} = $year_suffix;
		$ret{year}  = ( $year && $year ne "????" ? $year : "0" );
		if ($episode) {
			my %episode_hash = (
				title       => $episode,
				type	    => "episode",
				notes       => $notes,
				year        => ( $year ne "????" ? $year : "" ),
				years       => $ep_times,
				season      => $ep_season,
				episode_num => $ep_num
			);
			$ret{episode} = \%episode_hash;
		}

	}
	else {
		debug($line);
	}
	
	if ($ret{type}){
		$ret{unused} = $unused;
	}
	
	return %ret;
}
1;
