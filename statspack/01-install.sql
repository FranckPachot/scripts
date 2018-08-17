set echo on
-- show the paths where we have datafiles
select distinct regexp_replace(file_name,'[/][^/\\]*$') from dba_data_files order by 1;
-- Enter the the ASM diskgroup (+DATA) or the datafile for STATSPACK datafile
create tablespace STATSPACK datafile '&statspack_datafile./statspack.dbf' size 100M autoextend on maxsize 2G;
define default_tablespace='STATSPACK'
define temporary_tablespace='TEMP'
-- we set a random password. No need to know it as we will connect through sys
column random new_value perfstat_password noprint
select '"'||dbms_random.string('a',30)||'"' random from dual;
alter session set "_oracle_script"=true;
@?/rdbms/admin/spcreate
alter session set "_oracle_script"=false;
alter user perfstat grant connect through system;
grant create job to perfstat;
connect perfstat/&perfstat_password
whenever sqlerror continue
