set echo on
whenever sqlerror exit failure
-- replace +DATA by the ASM diskgroup ot the datafile for STATSPACK datafile
create tablespace STATSPACK datafile '+DATA' size 100M autoextend on maxsize 2G;
define default_tablespace='STATSPACK'
define temporary_tablespace='TEMP'
-- we set a random password. No need to know it as we will connect through sys
column random new_value perfstat_password noprint
select '"'||dbms_random.string('a',30)||'"' random from dual;
alter session set "_oracle_script"=true;
@?/rdbms/admin/spcreate
alter session set "_oracle_script"=false;
alter user perfstat connect through sys;
grant create job to perfstat;
