
DROP TABLE IF EXISTS CITIES;

DROP TABLE IF EXISTS COUNTRIES;

CREATE TABLE CITIES (
  COUNTRY_CODE varchar(2) NOT NULL DEFAULT '',
  CITY_NAME varchar(8) NOT NULL DEFAULT '',
  CANTON varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO CITIES
    (COUNTRY_CODE, CITY_NAME, CANTON)
VALUES
    ('CH', 'Lausanne', 'VD'),
    ('CH', 'Zurich', 'VD'),
    ('CH', 'Geneva', 'VD'),
    ('CH', 'Nyon', 'VD'),
    ('CH', 'Martigny', 'VS'),
    ('CH', 'Basel', 'BS')
;

alter table CITIES add
constraint CITIES_PK
 primary key(
 COUNTRY_CODE,
 CITY_NAME
 );

-- insert into CITIES values  ('CH', 'Lausanne', 'VD');

insert into CITIES values  ('CH', 'Vevey', 'VD');

  
CREATE TABLE COUNTRIES (
  COUNTRY_CODE varchar(2) NOT NULL DEFAULT '',
  COUNTRY_NAME varchar(11) DEFAULT NULL,
  POPULATION int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO COUNTRIES
    (COUNTRY_CODE, COUNTRY_NAME, POPULATION)
VALUES
    ('CH', 'Switzerland', 8.372),
    ('FR', 'France', 66.9),
    ('IT', 'Italy', 60.6),
    ('EG', 'Egypt', 95.69)
;

ALTER TABLE COUNTRIES add constraint COUNTRIES_PK  PRIMARY KEY (COUNTRY_CODE);

ALTER TABLE COUNTRIES add constraint COUNTRIES_UK  UNIQUE (COUNTRY_NAME);

select * from COUNTRIES;
select * from CITIES;


