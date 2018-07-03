
-- define here the statistics names you want to display
define names="'redo size','redo entries','undo change vector size','db block changes'"

set pagesize 0 feedback off linesize 1000 trimspool on verify off echo off
-- the following creates the _mystat_init.sql and _mystat_diff.sql for the defined statistics
with stats as (
  select rownum n,stat_id,name from (select stat_id,name from v$statname where name in (&names) order by stat_id)
)
select 'define LAG'||stat_id||'=0' from (select * from stats order by n)
union all
select 'column "CUR'||stat_id||'" new_value '||'LAG'||stat_id||' noprint' from (select * from stats order by n)
union all
select 'column "DIF'||stat_id||'" heading '''||name||''' format 999G999G999G999' from (select * from stats order by n)
.
spool _mystat_init.sql
/
spool off

with stats as (
  select rownum n,stat_id,name from (select stat_id,name from v$statname where name in (&names) order by stat_id)
)
select 'set termout off verify off' from dual
union all
select 'select ' from dual
union all
select '   '||decode(n,1,' ',',')||'"CUR'||stat_id||'" - '||'&'||'LAG'||stat_id||' "DIF'||stat_id||'"' from (select * from stats order by n)
union all
select '   '||',nvl("CUR'||stat_id||'",0) "CUR'||stat_id||'"' from (select * from stats order by n)
union all
--select ','''||'&'||'1'' comments' from dual
--union all
select q'[from (select stat_id,value from v$mystat join v$statname using(statistic#) where name in (&names)) pivot (avg(value)for stat_id in (]' from dual
union all
select '   '||decode(n,1,' ',',')||stat_id||' as "CUR'||stat_id||'"' from (select * from stats order by n)
union all
select '))' from dual
union all
select '.' from dual
union all
select 'set termout on' from dual
union all
select '/' from dual
.
spool _mystat_diff.sql
/
spool off

set pagesize 1000 feedback on linesize 1000 trimspool on verify on echo off define on

-- run this to initialize statistics
@ _mystat_init.sql

-- run this to get delta values from last query
@ _mystat_diff.sql
