package imdb::RelStore;

use strict;
use warnings;

BEGIN {
	unshift( @INC, "../" );
}

use lib::db;
use lib::IMDBUtil;
use imdb::cache;
use lib::param;
use lib::Log;

sub new {
	my $class = shift;
	my $obj = { context => undef };
	bless $obj, $class;

	delete_tables();
	imdb::cache::load();

	return $obj;
}

sub store_actor {
	my %ids   = ensure_ids(@_);
	my $class = shift;
	my $ref   = shift;
	if ( !$ref || !$$ref{actor} ) {
		return;
	}

	# check if the actor exists. Get aid from cache
	my $actor = $$ref{actor};
	my $aid = lib::cache::get_actor( $$ref{fullname}, $$ref{gender} );
	if ( !$aid ) {

		# if not, save him and add to cache
		my $sql =
		  "insert into actors (fullname,fname,lname,gender) values(?,?,?,?)";
		$aid =
		  lib::db::insert( $sql, $$actor{fullname}, $$actor{fname},
			$$actor{lname}, $$actor{gender} );
		lib::cache::add( $actor, $aid );
	}

	# save movie info.
	my $movie = $$ref{movie};
	if ( $$movie{type} eq "movie" ) {

		my $sql =
"insert into cast_movie(aid,mid,role,notes,credit_no) values (?,?,?,?,?)";
		lib::db::insert( $sql, $aid, $ids{mid}, $$movie{role}, $$movie{notes},
			$$movie{credit_no} );
	}
	elsif ( $$movie{type} eq "show" ) {
		if ( $$movie{episode} ) {
			my $episode = $$movie{episode};
			my $sql =
"insert into cast_episode(aid,eid,role,notes,credit_no) values (?,?,?,?,?)";
			lib::db::insert( $sql, $aid, $ids{eid}, $$movie{role},
				$$movie{notes}, $$movie{credit_no} );
		}
		else {
			my $sql =
"insert into cast_show(aid,sid,role,notes,credit_no) values (?,?,?,?,?)";
			lib::db::insert( $sql, $aid, $ids{sid}, $$movie{role},
				$$movie{notes}, $$movie{credit_no} );
		}
	}

}

sub store_actress {
	store_actor @_;
}

sub store_genre {
	my %ids = ensure_ids(@_);
	shift;
	my $ref = shift;
	if ( !$$ref{type} ) {
		print_r($ref);
		return;
	}
	my $id = imdb::cache::get_genre( $$ref{genre} );
	if ( !$id ) {
		my $lsql   = "insert into genre(name) values(?)";
		my @lparam = ( $$ref{genre} );
		$id = lib::db::insert( $lsql, @lparam );
		my %g = ( type => "genre", genre => $$ref{genre} );
		imdb::cache::add( \%g, $id );
	}

	if ( $$ref{type} eq "movie" ) {

		my $mlsql = "insert into movie_genre(mid,gid) values (?,?)";
		my @mparams = ( $ids{mid}, $id );
		lib::db::insert( $mlsql, @mparams );
	}
	else {

		my $ssql = "insert into show_genre(sid,gid) values(?,?)";
		my @sparam = ( $ids{sid}, $id );
		lib::db::insert( $ssql, @sparam );
	}

}

sub store_language {
	my %ids = ensure_ids(@_);
	shift;
	my $ref = shift;
	if ( !$$ref{type} ) {
		print_r($ref);
		return;
	}
	my $id = imdb::cache::get_language( $$ref{language} );
	if ( !$id ) {
		my $lsql   = "insert into language(name) values(?)";
		my @lparam = ( $$ref{language} );
		$id = lib::db::insert( $lsql, @lparam );
		my %m = ( type => "language", language => $$ref{language} );
		imdb::cache::add( \%m, $id );
	}

	if ( $$ref{type} ) {
		if ( $$ref{type} eq "movie" ) {
			my $mlsql =
			  "insert into movie_language(mid,lid,notes) values (?,?,?)";
			my @mparams = ( $ids{mid}, $id, $$ref{language_notes} );
			lib::db::insert( $mlsql, @mparams );
		}
		else {
			if ( $$ref{episode} ) {

				my $episode = $$ref{episode};
				my $esql =
				  "insert into episode_language(eid,lid,notes) values (?,?,?)";
				  if (!$ids{eid}){
				  	print_r($episode);
				  }
				my @eparams = ( $ids{eid}, $id, $$ref{language_notes} );
				lib::db::insert( $esql, @eparams );
			}
			else {
				my $ssql =
				  "insert into show_language(sid,lid,notes) values(?,?,?)";
				my @sparam = ( $ids{sid}, $id, $$ref{language_notes} );
				lib::db::insert( $ssql, @sparam );
			}
		}
	}

}

sub store_movie {
	shift;
	my $mref = shift;
	my %obj  = %$mref;
	my $lid  = shift;

	my %ret = ();

	my $type = $obj{type};

	if ( !$type ) {
		return;
	}

	if ( $type eq "movie" ) {

		# save the movie
		my $msql =
"insert into movies (title,year,year_end,vtype,notes,year_suffix) values (?,?,?,?,?,?)";
		my @params = (
			$$mref{title}, $$mref{year}, $$mref{year_end}, $$mref{vtype},
			$$mref{notes}, $$mref{year_suffix}
		);

		my $id = lib::db::insert( $msql, @params );
		imdb::cache::add( $mref, $id );

		$ret{mid} = $id;
	}
	else {

		# save the show
		# if the episode is not included, save the show
		my $sid =
		  imdb::cache::get_show( $$mref{title}, $$mref{year},
			$$mref{year_suffix} );
		if ( !$sid ) {
			my $ssql =
			  "insert into shows (title,year,year_suffix) values (?,?,?)";
			my @params = ( $$mref{title}, $$mref{year}, $$mref{year_suffix} );
			my $id = lib::db::insert( $ssql, @params );

			# retain the reference for future use
			imdb::cache::add( $mref, $id );
			$ret{sid} = $id;
			$sid = $id;
		}
		if ( $$mref{episode} ) {

			my $episode = $$mref{episode};

			# save the episode, get the reference from $obj{show}
			if (!$sid){
				lib::IMDBUtil::print_r(\%$mref);
			}
			my $esql =
"insert into show_episodes (sid,title,year,years_active,season,episode_no,notes) values (?,?,?,?,?,?,?)";

			my @eparams = (
				$sid, $$episode{title}, $$episode{year}, $$episode{years},
				$$episode{season}, $$episode{episode_num}, $$episode{notes}
			);
			my $eid = lib::db::insert( $esql, @eparams );
			$$episode{sid} = $sid;
			imdb::cache::add( $episode, $eid );
			$ret{eid} = $eid;
		}
	}
	return %ret;
}

sub store_rating {
	my %ids = ensure_ids(@_);
	shift;
	my $movie = shift;
	if ( !$movie ) {
		return;
	}
	if ( !$$movie{type} ) {
		return;
	}

	if ( $$movie{type} eq "movie" ) {

		my $sql =
"update movies set rating = ?, num_votes=?, distribution=? where mid = ?";
		lib::db::execute_sql( $sql, $$movie{rating}, $$movie{num_votes},
			$$movie{distribution}, $ids{mid} );
	}
	elsif ( $$movie{type} eq "show" ) {
		if ( $$movie{episode} ) {

			my $episode = $$movie{episode};

			my $sql =
"update show_episodes set rating = ?, num_votes=?, distribution=? where eid = ?";
			lib::db::execute_sql( $sql, $$movie{rating}, $$movie{num_votes},
				$$movie{distribution}, $ids{sid} );
		}
		else {

			my $sql =
"update shows set rating = ?, num_votes=?, distribution=? where sid = ?";
			lib::db::execute_sql( $sql, $$movie{rating}, $$movie{num_votes},
				$$movie{distribution}, $ids{sid} );
		}
	}

}

sub ensure_ids {
	my $this  = shift;
	my %ret   = ();
	my $movie = shift;

	if ( $$movie{type} eq "movie" ) {
		my $mid =
		  imdb::cache::get_movie( $$movie{title}, $$movie{year},
			$$movie{year_suffix} );
		if ( !$mid ) {
			my %id = $this->store_movie($movie);
			$ret{mid} = $id{mid};
		}
		else {
			$ret{mid} = $mid;
		}

	}
	else {
		my $sid =
		  imdb::cache::get_show( $$movie{title}, $$movie{year},
			$$movie{year_suffix} );
		if ( !$sid ) {
			my %id = $this->store_movie($movie);
			if ( $id{sid} ) {
				$ret{sid} = $id{sid};
				$sid = $id{sid};
			}
			if ( $id{eid} ) {
				$ret{eid} = $id{eid};
			}
		}
		else {
			$ret{sid} = $sid;
		}
		if ( $$movie{episode} ) {
			my $episode = $$movie{episode};
			my $eid =
			  imdb::cache::get_episode( $sid, $$episode{title},
				$$episode{season}, $$episode{episode_num} );
			if ( !$eid ) {
				my %id = $this->store_movie($movie);
				if ( $id{sid} ) {
					$ret{sid} = $id{sid};
				}
				if ( $id{eid} ) {
					$ret{eid} = $id{eid};
				}
			}
			else {
				$ret{eid} = $eid;
			}
		}
	}
	return %ret;

}

sub delete_tables {
	
#	if ( get_param(SHOULD_CLEAR_DATABASE) ) {
#		my $tables = get_param(IMPORT_LIST);
#
#		foreach my $t (@$tables) {
#			INFO("Deleting table $t");
#			lib::db::execute_sql("delete from $t");
#			lib::db::commit();
#		}
#	} 

}
1;

