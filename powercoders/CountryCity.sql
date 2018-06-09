
DROP TABLE IF EXISTS `cities`;

DROP TABLE IF EXISTS `countries`;

CREATE TABLE `countries` (
  `Country_Code` varchar(2) NOT NULL DEFAULT '',
  `Country_Name` varchar(11) DEFAULT NULL,
  `Population` int(11) DEFAULT NULL,
  PRIMARY KEY (`Country_Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `cities` (
  `Country_Code` varchar(2) NOT NULL DEFAULT '',
  `City_Name` varchar(8) NOT NULL DEFAULT '',
  `Canton` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`Country_Code`,`City_Name`),
  CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`Country_Code`) REFERENCES `countries` (`Country_Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

