define hour_range="between '04' and '08'"
define days_range="between trunc(sysdate -15) and sysdate"
define dow_range="between 1 and 5"
define max_sql=20

set echo off feedback off pagesize 0 linesize 1000 trimspool on define on verify off 

select script,dbid,sql_id,plan_hash_value,yyyymmdd,rownum n
 ,to_char(100*ela_ratio,'9999')||'%',to_char(ela_rank,'999'),to_char(100*cpu_time_ratio,'999')||'%',to_char(100*iowait_ratio,'999')||'%'
from (
select '@@ TOPSQL-statement&'||'mode..sql' script,dbid,sql_id,plan_hash_value,to_char(min(begin_interval_time),'yyyy-mm-dd') yyyymmdd
  ,max(ela_ratio) ela_ratio ,min(ela_rank) ela_rank , sum(iowait_delta)/sum(elapsed_time_delta) iowait_ratio, sum(cpu_time_delta)/sum(elapsed_time_delta) cpu_time_ratio
from (
  select dbid,instance_number,snap_id,sql_id,plan_hash_value,elapsed_time_delta,begin_interval_time
  ,elapsed_time_delta/sum(elapsed_time_delta)over(partition by dbid,instance_number,snap_id) ela_ratio
  ,rank()over(partition by dbid,instance_number,snap_id order by elapsed_time_delta desc) ela_rank
  ,iowait_delta,cpu_time_delta
  from dba_hist_sqlstat s
  join dba_hist_snapshot n using (dbid,instance_number,snap_id)
    where begin_interval_time &days_range -- DAYS HISTORY
      and to_char(begin_interval_time,'HH24') &hour_range -- DAY HOURS
      and decode(to_char(begin_interval_time,'D'),to_char(date'1-1-3','D'),1,to_char(date'1-1-4','D'),2,to_char(date'1-1-5','D'),3,to_char(date'1-1-6','D'),4,to_char(date'1-1-7','D'),5,to_char(date'1-1-8','D'),6,to_char(date'1-1-9','D'),7) &dow_range -- DAY OF WEEK
)
-- keep only top-n in each snapshot, and only those that have enough relative db time
where ela_rank <= 10 or ela_ratio > 5/100
group by dbid,sql_id,plan_hash_value
order by sum(elapsed_time_delta) desc
) where rownum <= &max_sql
.


spool TOPSQL-01.tmp
/
spool off

set pagesize 1000 
set markup html on spool on entmap on preformat off -
	head '-
	<style type="text/css"> -
 -
 h1 { color:#f00 ; } -
 h2 { color:#f00 ; } -
 table {border:2px solid #fff;} -
 th {background:#f00; border:3px solid #fff; color:#fff;white-space: nowrap;} -
 td {white-space: nowrap;} -
 tr {border:3px solid #fff; background:#eee;} -
	</style>' -
	body 'text=black bgcolor=fffffff align=left' -
	table 'align=center width=99% border=3 bordercolor=black bgcolor=white'
column HTML entmap off
spool TOPSQL.html
set define on

define mode='-toc'
set heading off markup html off
prompt <H1>SQL Statement summary</H1>
prompt <table>
prompt <tr><th>Rank</th><th>SQL_ID</th><th>PLAN_HASH_VALUE</th><th>highest DB time part</th><th>lowest rank/snapshot</th><th>CPU</th><th>I/O</th><th>SQL text (truncated)</th></tr>
@@ TOPSQL-01.tmp
set heading off markup html off
prompt </table>
set heading on markup html on entmap on preformat off 

define mode='-detail'
@@ TOPSQL-01.tmp
set heading off markup html off
prompt <H1>Database Load History</H1>
prompt <p>Days &days_range , Hours &hour_range , Day of Week &dow_range (Monday=1)</p>
set heading on markup html on preformat off
@@ DatabaseLoadHistoryFromAWR.sql
spool off

exit



