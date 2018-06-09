/*
This can be run with:

C:\MAMP\bin\mysql\bin\mysql test --port=3306 --host=localhost --user root --password
root
\. CountryCity.sql

*/


DROP TABLE IF EXISTS CITIES;

DROP TABLE IF EXISTS COUNTRIES;

CREATE TABLE CITIES (
  Country_Code varchar(2) NOT NULL DEFAULT '',
  City_Name varchar(8) NOT NULL DEFAULT '',
  Canton varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO CITIES
    (Country_Code, City_Name, Canton)
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

-- this raises an error (duplicate) -- insert into CITIES values  ('CH', 'Lausanne', 'VD');

insert into CITIES values  ('CH', 'Vevey', 'VD');

  
CREATE TABLE countries (
  Country_Code varchar(2) NOT NULL DEFAULT '',
  Country_Name varchar(11) DEFAULT NULL,
  Population int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO countries
    (Country_Code, Country_Name, Population)
VALUES
    ('CH', 'Switzerland', 8.372),
    ('FR', 'France', 66.9),
    ('IT', 'Italy', 60.6),
    ('EG', 'Egypt', 95.69)
;

select * from COUNTRIES;

select Country_Name, Population from COUNTRIES;

select Country_Name, Population from COUNTRIES  where Country_Code ='CH';

select * from COUNTRIES where population>90;

select * from COUNTRIES where population between 20 and 70;

select * from COUNTRIES where Country_Name like 'F%';

select * from COUNTRIES where Country_Name like '_taly';

select * from COUNTRIES where Country_Code in ('FR','IT');


insert into CITIES(Country_Code,City_Name,Canton) values('FR','Paris',null);

select * from CITIES where canton not in ('VD','BS','VS');

select * from CITIES where canton ='';

select * from CITIES where canton is null;



ALTER TABLE countries add constraint Countries_PK  PRIMARY KEY (Country_Code);

ALTER TABLE countries add constraint Countries_UK  UNIQUE (Country_Name);

select * from COUNTRIES;
select * from CITIES;

select Country_Code,City_Name from CITIES;

select Country_Code,Country_Name from COUNTRIES;

select Country_Name,City_Name from CITIES 
join COUNTRIES using(Country_Code);

select Country_Name,City_Name from CITIES 
join COUNTRIES on(CITIES.Country_Code=COUNTRIES.Country_Code);

select Country_Name,City_Name from CITIES 
join COUNTRIES using(Country_Code);

select Country_Name,City_Name from CITIES 
natural join COUNTRIES;

select Country_Name , City_Name from CITIES , COUNTRIES 
where (CITIES.Country_Code=COUNTRIES.Country_Code);

select Country_Name,City_Name from CITIES 
join COUNTRIES on(CITIES.Country_Code=COUNTRIES.Country_Code);

select COUNTRIES.Country_Name, CITIES.City_Name from CITIES 
join COUNTRIES on(CITIES.Country_Code=COUNTRIES.Country_Code);

select CO.Country_Name, CT.City_Name from CITIES CT
join COUNTRIES CO on(CT.Country_Code=CO.Country_Code);

select CO.Country_Name as Country, CT.City_Name as City
from CITIES CT
join COUNTRIES CO on(CT.Country_Code=CO.Country_Code);

select Country_Name,City_Name from CITIES 
inner join COUNTRIES using(Country_Code);

select Country_Name,City_Name from CITIES 
right outer join COUNTRIES using(Country_Code);

select sum("POPULATION") from COUNTRIES  where "COUNTRY_CODE" not in ('CH');
select sum("POPULATION") from COUNTRIES  where "COUNTRY_CODE" not in ('CH') group by "COUNTRY_Name";
select "COUNTRY_Name",sum("POPULATION") from COUNTRIES  where "COUNTRY_CODE" not in ('CH') group by "COUNTRY_Name";

update COUNTRIES set population=population+10 where Country_Code!='CH';

insert into COUNTRIES (Country_Code,Country_Name) values ('BE','Belgium');

delete from COUNTRIES where population>100;

alter table CITIES add foreign key 
 (Country_Code) references COUNTRIES(Country_Code);

-- this fails with parent key not found-- delete from COUNTRIES where Country_code='CH';

 