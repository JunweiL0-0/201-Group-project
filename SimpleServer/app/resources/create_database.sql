# MySQL scripts for dropping existing tables and recreating the database table structure

DROP TABLE IF EXISTS `images`;


CREATE TABLE `images` (
  `id`          int(11)       NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(2048) NULL,
  `image_filename`  VARCHAR(64)  NOT NULL,

  UNIQUE KEY (`image_filename`),
  PRIMARY KEY (`id`)
);

