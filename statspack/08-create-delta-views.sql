create or replace view PERFSTAT.DELTA$SNAPSHOT as select
 e.SNAP_ID
 ,DBID
 ,INSTANCE_NUMBER
 ,SNAP_TIME
 ,lag(e.SNAP_ID)over(partition by DBID,INSTANCE_NUMBER,STARTUP_TIME order by e.snap_id) BEGIN_SNAP_ID
 ,ROUND((SNAP_TIME-lag(SNAP_TIME)over(partition by DBID,INSTANCE_NUMBER,STARTUP_TIME order by e.snap_id))*24*60*60) SNAP_
SECONDS
 ,STARTUP_TIME,PARALLEL, VERSION, DB_NAME, INSTANCE_NAME, HOST_NAME
FROM PERFSTAT.STATS$SNAPSHOT e
 join stats$database_instance i using(STARTUP_TIME,DBID,INSTANCE_NUMBER)
/
create or replace view PERFSTAT.DELTA$SYSSTAT as select
 n.snap_time,n.snap_seconds
 ,e.SNAP_ID
 ,e.DBID
 ,e.INSTANCE_NUMBER
 ,e.STATISTIC#
 ,e.NAME
 ,e.VALUE-b.VALUE VALUE
 ,n.startup_time instance_startup_time,n.db_name,n.instance_name,n.host_name
from PERFSTAT.DELTA$SNAPSHOT n join PERFSTAT.STATS$SYSSTAT e
 on(e.snap_id=n.snap_id and e.dbid=n.dbid and
 e.instance_number=n.instance_number)
 join PERFSTAT.STATS$SYSSTAT b
 on(n.begin_snap_id=b.snap_id AND e.dbid=b.dbid AND
 e.instance_number=b.instance_number and e.NAME=b.NAME)
/
