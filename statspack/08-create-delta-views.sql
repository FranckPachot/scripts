define owner=PERFSTAT
define prefix=DELTA

whenever sqlerror exit failure
whenever  oserror exit failure

CREATE OR REPLACE VIEW &owner..&prefix.$SNAPSHOT AS
SELECT
  e.SNAP_ID
 ,e.DBID
 ,e.INSTANCE_NUMBER
 ,e.SNAP_TIME
 ,DECODE(SIGN(b.snap_time-e.startup_time),-1,NULL,ROUND((e.SNAP_TIME-b.SNAP_TIME)*24*60*60)) SNAP_SECONDS
 ,e.STARTUP_TIME,PARALLEL, VERSION, DB_NAME, INSTANCE_NAME, HOST_NAME
FROM  &owner..STATS$SNAPSHOT b  join &owner..STATS$SNAPSHOT e
 ON(e.snap_id=b.snap_id+1 AND e.dbid=b.dbid AND e.instance_number=b.instance_number)
 join stats$database_instance i ON (i.startup_time=e.startup_time AND e.dbid=i.dbid AND e.instance_number=i.instance_number)
 where not ( e.startup_time between b.snap_time and e.snap_time)
/

BEGIN
 FOR v IN (
  SELECT table_name , '&prefix.'||SUBSTR(table_name,INSTR(table_name,'$')) view_name FROM ALL_TAB_COLUMNS
 WHERE table_name LIKE 'STATS$%' AND table_name NOT IN ('STATS$SNAPSHOT','STATS$DATABASE_INSTANCE')
 AND nullable='N' AND column_name IN ('SNAP_ID','DBID','INSTANCE_NUMBER') GROUP BY table_name HAVING COUNT(*) = 3
 ) LOOP
  dbms_output.put_line('');
  dbms_output.put_line('create or replace view &owner..'||v.view_name||' as select n.snap_time,n.snap_seconds');
  FOR c IN (
   SELECT * FROM ALL_TAB_COLUMNS
  WHERE NOT(nullable='Y' AND data_type  IN ('NUMBER')) AND table_name=v.table_name AND owner='&owner.'
  ) LOOP
  dbms_output.put_line(' ,e.'||c.column_name);
  END LOOP;
  FOR c IN (
   SELECT * FROM ALL_TAB_COLUMNS
  WHERE nullable='Y' AND data_type  IN ('NUMBER') AND table_name=v.table_name AND owner='&owner.'
  ) LOOP
  dbms_output.put_line(' ,e.'||c.column_name||'-b.'||c.column_name||' '||c.column_name);
  END LOOP;
  dbms_output.put_line(' ,n.startup_time instance_startup_time,n.db_name,n.instance_name,n.host_name');
  dbms_output.put_line('from &owner..&prefix.$SNAPSHOT n join &owner..'||v.table_name||' e ');
  dbms_output.put_line(' on(e.snap_id=n.snap_id and e.dbid=n.dbid and e.instance_number=n.instance_number)');
  dbms_output.put_line(' join &owner..'||v.table_name||' b'  );
  dbms_output.put(' on(e.snap_id=b.snap_id+1 AND e.dbid=b.dbid AND e.instance_number=b.instance_number');
  FOR c IN (
   SELECT * FROM ALL_CONS_COLUMNS join ALL_CONSTRAINTS USING(owner,constraint_name)
  WHERE constraint_type='P' AND column_name NOT IN ('SNAP_ID','DBID','INSTANCE_NUMBER')
  AND owner='&owner.' AND ALL_CONSTRAINTS.table_name=v.table_name
  ) LOOP
  dbms_output.put(' and e.'||c.column_name||'=b.'||c.column_name);
  END LOOP;
  dbms_output.put_line(')');
  dbms_output.put_line('/');
 END LOOP;
 dbms_output.put_line('');
END;
.

set feedback off serveroutput on size 100000
spool delta.tmp
/
spool off
set feedback on echo on
start delta.tmp
