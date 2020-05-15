merge into STATS$SNAPSHOT s -- adds a comment on end snapshot about the load
using (
select
 dbid,instance_number,snap_id
 ,ltrim(substr(listagg(name||':'||ltrim(to_char(time_waited_micro/elapsed_micro,'09.9'))||' ')
 within group(order by round(time_waited_micro/elapsed_micro,1) desc,name nulls first),1,21)
 ,':') ucomment
from (
select
 dbid,instance_number,snap_id
 ,decode(name,'DB time','','DB CPU','CPU','User I/O','I/O','System I/O','I/O',substr(name,1,3)) name
 ,time_waited_micro-lag(time_waited_micro)over(partition by dbid,instance_number,name order by snap_id) time_waited_micro
 ,case when lag(snap_time)over(partition by dbid,instance_number,name order by snap_id)-startup_time > 0 then
 (snap_time-lag(snap_time)over(partition by dbid,instance_number,name order by snap_id))*24*60*60*1e6
 end elapsed_micro
 from (
 select dbid,instance_number,snap_id,wait_class name,sum(time_waited_micro) time_waited_micro
 from stats$system_event join v$event_name using(event_id)
 where wait_class not in ('Idle')
 group by dbid,instance_number,snap_id,wait_class
 union all
 select dbid,instance_number,snap_id,stat_name name,value
 from stats$sys_time_model join stats$time_model_statname using (stat_id) where stat_name in ('DB time','DB CPU')
 ) join stats$snapshot using(dbid,instance_number,snap_id) where ucomment is null
) where elapsed_micro >1e6 and time_waited_micro>1e6
group by dbid,instance_number,snap_id
) l on (s.snap_id=l.snap_id and s.dbid=l.dbid and s.instance_number=l.instance_number)
when matched then update set s.ucomment=l.ucomment;
