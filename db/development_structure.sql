CREATE TABLE `albums` (
  `id` int(11) NOT NULL auto_increment,
  `artist_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `year` int(2) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_albums_on_artist_id_and_name` (`artist_id`,`name`),
  KEY `index_albums_on_artist_id` (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `artists` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_artists_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `last_import_errors` (
  `id` int(11) NOT NULL auto_increment,
  `file_name` varchar(255) NOT NULL,
  `error` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `media` (
  `id` int(11) NOT NULL auto_increment,
  `media_path_id` int(11) NOT NULL,
  `file_name` text NOT NULL,
  `file_mtime` datetime NOT NULL,
  `folder_name` text,
  `file_size` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `artist_id` int(11) default NULL,
  `album_id` int(11) default NULL,
  `year` int(2) default NULL,
  `track` int(2) default NULL,
  `genre` varchar(40) default NULL,
  `status` int(2) default '0',
  `length` float default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_media_on_artist_id` (`artist_id`),
  KEY `index_media_on_album_id` (`album_id`),
  KEY `index_media_on_media_path_id` (`media_path_id`),
  KEY `index_media_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `media_paths` (
  `id` int(11) NOT NULL auto_increment,
  `filesystem_path` text NOT NULL,
  `virtual_path` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `rmedial_settings` (
  `id` int(11) NOT NULL auto_increment,
  `static_file_path` varchar(255) default NULL,
  `path_to_ffmpeg` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (1)