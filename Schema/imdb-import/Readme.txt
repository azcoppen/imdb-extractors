IMDB Data Dump Parser
--------------------------------------------------------------------
Date: 2/10/2010

PreRequisites
----------------
1) Perl Runtime Environment 5.0 or higher.
2) MySQL Version 5.1
3) Perl Module Dependencies: (Make sure the following modules are installed)
	a)DBI
	b)DBI::MySql
4) Data Files:
IMDB data is available as dump files from ftp:// and some other mirrors at.
Download and unzip files to data/ directory

Parameter Settings
---------------------------------
The 
# the parameter file
data.folder=data/

# Database parameters
database.url=DBI:mysql:imdb_full:localhost
database.handler=lib::MySQLDB
database.storageHandler=imdb::RelStore
database.user=imdb
database.pwd=imdb

# stuff to import
import.movies=1
import.actors=0
import.actresses=0
import.genres=1
import.language=1
import.ratings=1

# logfile configuration
log.logfile=log/logfile.log
log.unprocessed=log/unprocessed.log






Contact:
Abhijith Kashyap
abhijithk@gmail.com 


