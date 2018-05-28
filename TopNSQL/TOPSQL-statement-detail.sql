column hours heading "hours" format 999
set heading off markup html off
prompt <A name="&2./&3."/>
prompt <H1>Top-&5 SQL: SQL_ID: &2 Plan hash: &3</H1>

prompt <H2>Execution statistics for &2 since &4</H2>

set heading on markup html on preformat off

select x.*,
 case 
	when "executions"/hours/60/60 > 1 then '+++'||round("executions"/hours/60/60,1)||' exe/second.' 
	when "executions"/hours/60 > 1 then '+'||round("executions"/hours/60,1)||' exe/minute.' 
	when "executions"/hours > 1 then '+'||round("executions"/hours,1)||' exe/hour.' 
 end 
 "remark"
 from (  
  select 
  db_name "db",host_name "host",instance_name "inst",to_char(min(begin_interval_time),'yyyy-mm-dd hh24:mi') "begin",to_char(max(end_interval_time),'yyyy-mm-dd hh24:mi') "end",24*(cast(max(end_interval_time) as date)-cast(min(begin_interval_time) as date)) hours
        ,sum(executions_delta) "executions"
        ,round(sum(rows_processed_delta)/sum(executions_delta)) "rows/exe"
        ,round(sum(buffer_gets_delta)/sum(executions_delta)) "lr/row"
        ,round(sum(disk_reads_delta)/sum(executions_delta)) "pr/exe"
        ,round(sum(buffer_gets_delta)/sum(executions_delta)) "lr/exe"
        ,round(sum(elapsed_time_delta)/sum(executions_delta)/1000) "ela ms/exe"
        ,round(sum(iowait_delta)/sum(executions_delta)/1000) "i/o ms/exe"
        ,round(sum(cpu_time_delta)/sum(executions_delta)/1000) "cpu ms/exe"
        ,round(sum(apwait_delta)/sum(executions_delta)/1000) "ap ms/exe"
        ,round(sum(ccwait_delta)/sum(executions_delta)/1000) "cc ms/exe"  
	,to_char(sum(elapsed_time_delta)/1000000/60/60,'999999')||' hours' "DB time"
  from dba_hist_sqlstat s
  join dba_hist_snapshot n using(dbid,instance_number,snap_id) 
  join dba_hist_database_instance d using(dbid,instance_number,startup_time)
  where dbid=&1 and  sql_id='&2' and to_char(begin_interval_time,'yyyy-mm-dd') >= '&4' and executions_delta>0
  group by db_name,host_name,instance_name,trunc(begin_interval_time)
) x
order by "begin" desc
/

set heading off markup html off

set long 10000

prompt <H2>Statement and execution plan for &2</H2>

set heading on markup html on preformat on

select sql_text from dba_hist_sqltext where dbid=&1 and sql_id='&2' and (select count(*) from  table(dbms_xplan.display_awr('&2',&3,null,'BASIC')))<=0
/

select plan_table_output from table(dbms_xplan.display_awr('&2',&3,null,'TYPICAL +PREDICATE +OUTLINE +PEEKED_BINDS'))
/

set heading off markup html off 

prompt <H2>Some bind captures for &2</H2>


prompt <table>
select * from (
  select 
  case when position = min(position)over(partition by sql_id) then '<tr>' end
  || '<th>'||name||' <i>'||datatype_string||'</i></th>'
  ||case when position = max(position)over(partition by sql_id) then '</tr>' end
  TEXT 
  from dba_hist_sql_bind_metadata where sql_id='&2'
  order by sql_id,position
)
union all
select text from (
  select distinct snap_id,sql_id,position,
  case when position = min(position)over(partition by sql_id) then '<tr>' end
  || '<td>'||value_string||'</td>'
  ||case when position = max(position)over(partition by sql_id) then '</tr>' end
  TEXT,dense_rank()over(order by snap_id desc) r
  from dba_hist_sqlbind where dbid=&1 and sql_id='&2'
  order by snap_id desc,sql_id,position
) where r <= 5
/
prompt </table>

prompt <H2>Some captured info about sessions running &2</H2>

set heading on markup html on entmap on preformat off 

select * from (  
select min(sample_time),max(sample_time)
 ,program,module,action,client_id,sql_opcode,plsql_entry_object_id,plsql_entry_subprogram_id,plsql_object_id,plsql_subprogram_id 
from dba_hist_active_sess_history where sql_id='a0bk719uwgcg4'
group by program,module,action,client_id,sql_opcode,plsql_entry_object_id,plsql_entry_subprogram_id,plsql_object_id,plsql_subprogram_id 
order by max(sample_time) desc
) where rownum <=10
/



