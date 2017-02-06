CREATE DATABASE `imdb_full` /*!40100 DEFAULT CHARACTER SET latin1 */;

DROP TABLE IF EXISTS `imdb_full`.`actor`;
CREATE TABLE  `imdb_full`.`actor` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fullname` varchar(100) NOT NULL,
  `fname` varchar(50) NOT NULL,
  `lname` varchar(50) DEFAULT NULL,
  `gender` varchar(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`cast_episode`;
CREATE TABLE  `imdb_full`.`cast_episode` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(10) unsigned NOT NULL,
  `eid` int(10) unsigned NOT NULL,
  `role` varchar(200) DEFAULT NULL,
  `notes` varchar(200) DEFAULT NULL,
  `credit_no` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`cast_movie`;
CREATE TABLE  `imdb_full`.`cast_movie` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(10) unsigned NOT NULL,
  `mid` int(10) unsigned NOT NULL,
  `role` varchar(200) DEFAULT NULL,
  `notes` varchar(200) DEFAULT NULL,
  `credit_no` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`cast_show`;
CREATE TABLE  `imdb_full`.`cast_show` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(10) unsigned NOT NULL,
  `sid` int(10) unsigned NOT NULL,
  `role` varchar(200) DEFAULT NULL,
  `notes` varchar(200) DEFAULT NULL,
  `credit_no` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`episode_language`;
CREATE TABLE  `imdb_full`.`episode_language` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eid` int(10) unsigned NOT NULL,
  `lid` int(10) unsigned NOT NULL,
  `notes` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`genre`;
CREATE TABLE  `imdb_full`.`genre` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`language`;
CREATE TABLE  `imdb_full`.`language` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`movie_genre`;
CREATE TABLE  `imdb_full`.`movie_genre` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mid` int(10) unsigned NOT NULL,
  `gid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`movie_language`;
CREATE TABLE  `imdb_full`.`movie_language` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mid` int(10) unsigned NOT NULL,
  `lid` int(10) unsigned NOT NULL,
  `notes` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`movies`;
CREATE TABLE  `imdb_full`.`movies` (
  `mid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(400) NOT NULL,
  `year` int(10) unsigned DEFAULT NULL,
  `year_end` int(10) unsigned DEFAULT NULL,
  `vtype` varchar(3) DEFAULT NULL,
  `notes` varchar(50) DEFAULT NULL,
  `rating` float DEFAULT NULL,
  `num_votes` int(10) unsigned DEFAULT NULL,
  `distribution` varchar(15) DEFAULT NULL,
  `year_suffix` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`mid`)
) ENGINE=InnoDB AUTO_INCREMENT=2946946 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`show_episodes`;
CREATE TABLE  `imdb_full`.`show_episodes` (
  `eid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sid` int(10) unsigned NOT NULL,
  `title` varchar(500) DEFAULT NULL,
  `season` int(10) unsigned DEFAULT NULL,
  `episode_no` int(10) unsigned DEFAULT NULL,
  `year` int(10) unsigned DEFAULT NULL,
  `years_active` varchar(50) DEFAULT NULL,
  `notes` varchar(45) DEFAULT NULL,
  `rating` float DEFAULT NULL,
  `num_votes` int(10) unsigned DEFAULT NULL,
  `distribution` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`eid`)
) ENGINE=InnoDB AUTO_INCREMENT=884394 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`show_genre`;
CREATE TABLE  `imdb_full`.`show_genre` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sid` int(10) unsigned NOT NULL,
  `gid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`show_language`;
CREATE TABLE  `imdb_full`.`show_language` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sid` int(10) unsigned NOT NULL,
  `lid` int(10) unsigned NOT NULL,
  `notes` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `imdb_full`.`shows`;
CREATE TABLE  `imdb_full`.`shows` (
  `sid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(500) NOT NULL,
  `year` int(10) unsigned DEFAULT NULL,
  `year_end` int(10) unsigned DEFAULT NULL,
  `rating` float DEFAULT NULL,
  `num_votes` int(10) unsigned DEFAULT NULL,
  `distribution` varchar(15) DEFAULT NULL,
   `year_suffix` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB AUTO_INCREMENT=709835 DEFAULT CHARSET=latin1;
