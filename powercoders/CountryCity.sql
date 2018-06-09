
DROP TABLE IF EXISTS CITIES;

DROP TABLE IF EXISTS COUNTRIES;

CREATE TABLE CITIES (
  `Country_Code` varchar(2) NOT NULL DEFAULT '',
  `City_Name` varchar(8) NOT NULL DEFAULT '',
  `Canton` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO CITIES
    (`Country_Code`, `City_Name`, `Canton`)
VALUES
    ('CH', 'Lausanne', 'VD'),
    ('CH', 'Zurich', 'VD'),
    ('CH', 'Geneva', 'VD'),
    ('CH', 'Nyon', 'VD'),
    ('CH', 'Martigny', 'VS'),
    ('CH', 'Basel', 'BS')
;

alter table CITIES add
constraint Cities_PK
 primary key(
 Country_Code,
 City_Name
 );

-- insert into CITIES values  ('CH', 'Lausanne', 'VD');

insert into CITIES values  ('CH', 'Vevey', 'VD');

  
CREATE TABLE `countries` (
  `Country_Code` varchar(2) NOT NULL DEFAULT '',
  `Country_Name` varchar(11) DEFAULT NULL,
  `Population` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `countries`
    (`Country_Code`, `Country_Name`, `Population`)
VALUES
    ('CH', 'Switzerland', 8.372),
    ('FR', 'France', 66.9),
    ('IT', 'Italy', 60.6),
    ('EG', 'Egypt', 95.69)
;

ALTER TABLE `countries` add constraint Countries_PK  PRIMARY KEY (`Country_Code`);

ALTER TABLE `countries` add constraint Countries_UK  UNIQUE (`Country_Name`);

select * from COUNTRIES;
select * from CITIES;


