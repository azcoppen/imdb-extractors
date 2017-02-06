package lib::db;
use strict;
use warnings;
BEGIN {
	unshift( @INC, "../" );
}
our @EXPORT = ('disconnect_from_database','execute_sql','connect_to_database','commit','insert');

our $impl;

sub init{
	my $class = shift;
	$impl = $class->new;
}

# Connect to the database
sub connect_to_database {
	$impl->connect_to_database (@_);
}

sub commit{
	$impl->commit;
}

#disconnect from the database
sub disconnect_from_database {
	$impl->disconnect_from_database();
}
#execute a statement, return the executed statement.
sub execute_sql {
	return $impl->execute_sql(@_);
}

sub insert {
	return $impl->insert(@_);
}


# MySQL implementation of database connection.
package lib::MySQLDB;
BEGIN {
	unshift( @INC, "../" );
}

use lib::IMDBUtil;
use DBI;
use DBI qw(:sql_types);

our $conn;

sub new {
	my $class = shift;
	my $obj = { context => undef };
	bless $obj, $class;
	return $obj;
}

# Connect to the database
sub connect_to_database {
	shift;
	my ($connStr,$u,$p) = @_;
	$conn = DBI->connect( $connStr, $u, $p ,{AutoCommit => 0}) or die ;
}

sub commit{
	$conn->commit;
}

#disconnect from the database
sub disconnect_from_database {
	$conn->disconnect();
}
#execute a statement, return the executed statement.
sub execute_sql {
	shift;
	my $sql = shift;
	my @params = @_;
	my $stm = $conn->prepare($sql);
	my $i=1;
	foreach my $p (@params){
		$stm->bind_param($i++,$p);
	} 
	$stm->execute or die " cannot execute sql : ".$sql;
	
	return $stm;
}

sub insert {
	shift;
	my $sql = shift;
	my @params = @_;
		
	my $stm = $conn->prepare($sql);
	my $i=1;
	foreach my $p (@params){
		if (!$p){
			$stm->bind_param($i++,undef);
		}
		else {
			$stm->bind_param($i++,$p);
		}
		
	} 
	
	$stm->execute or die " cannot execute sql : ".$sql."with params : ".join(" -*- ",@params);
	
	return $conn->{ q{mysql_insertid}};
}
1;
