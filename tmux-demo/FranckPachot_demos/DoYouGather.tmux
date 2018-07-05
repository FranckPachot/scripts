tmux display-message "testing ping to server..."
ping -w 5000 -n 1 ${HOST:-192.168.56.188} || exit
tmux display-message "server ok."

tmux kill-window -t "DoYouGather"
tmux new-window -k -n "DoYouGather" 
sleep 1
tmux send-keys "ssh oracle@${HOST:-192.168.56.188}" C-M
tmux display-message "wait for tmux window..."
sleep 1

--- ######################################################3##############################3
--- ############################# begin sqlcl env #######################################3
tmux send-keys "echo set sqlformat ansiconsole > /tmp/login.sql " C-M
tmux send-keys "alias sql='SQLPATH=/tmp JAVA_HOME="'$ORACLE_HOME/jdk bash $ORACLE_HOME'"/sqldeveloper/sqlcl/bin/sql'" C-M
tmux send-keys '[ -r /media/sf_Soft/sqlcl/bin/sql ] &&' "alias sql='SQLPATH=/tmp JAVA_HOME="'$ORACLE_HOME/jdk bash '"/media/sf_Soft/sqlcl/bin/sql'" C-M
tmux send-keys "rm -f login.sql" C-M

tmux send-keys ". oraenv <<< CDB1" C-M
tmux send-keys -t :.0 "sql sys/oracle@//localhost/PDB1${DOMAIN} as sysdba" C-M
tmux send-keys "alter system flush shared_pool; " C-M
tmux send-keys "alter system set shared_pool_size=400M scope=memory; " C-M
tmux send-keys "alter session set container=PDB1; " C-M
tmux send-keys "alter system flush shared_pool; " C-M

tmux send-keys "" C-M

tmux send-keys "set linesize 100 pagesize 1000 long 10000 time on" C-M
tmux send-keys "column plan_table_output format a100 trunc" C-M
tmux send-keys "column window_name format a16 trunc; " C-M
tmux send-keys "column window_next_time format a32 trunc; " C-M
tmux send-keys "column window_start_time format a32 trunc; " C-M
tmux send-keys "column window_end_time format a32 trunc; " C-M
tmux send-keys "column last_good_date format a32 trunc; " C-M
tmux send-keys "column last_try_date format a32 trunc; " C-M
tmux send-keys "column autotask_status format a15 trunc; " C-M
tmux send-keys "column optimizer_stats format a15 trunc; " C-M
tmux send-keys "column task_name format a17 trunc; " C-M
tmux send-keys "column client_name format a31 trunc; " C-M
tmux send-keys "column pname format a15" C-M
tmux send-keys "column sname format a10" C-M
tmux send-keys "column pval1 format 99999999D9" C-M
tmux send-keys "column calculated format 999999D9" C-M
tmux send-keys "column pval2 format a10" C-M
tmux send-keys "column formula format a60" C-M
tmux send-keys "grant dba to DEMO identified by demo; " C-M
tmux send-keys "connect demo/demo@&_connect_identifier; " C-M
tmux send-keys "alter session set statistics_level=all; " C-M
tmux send-keys "alter session set nls_date_format='dd-mon-yy hh24:mi:ss'; " C-M
tmux send-keys "set serveroutput off define off; " C-M
tmux send-keys 'alter session set "_optimizer_batch_table_access_by_rowid"=false; ' C-M

tmux send-keys "drop table demo; " C-M
tmux send-keys "drop table DEMO.DEMO; " C-M
tmux send-keys "drop table DEMO.HIST; " C-M
tmux send-keys "alter system flush shared_pool; " C-M
tmux send-keys "exec dbms_stats.delete_table_prefs(user,'DEMO_GTT','GLOBAL_TEMP_TABLE_STATS'); " C-M
tmux send-keys "drop table DEMO.DEMO_GTT; " C-M
tmux send-keys "drop table DEMO.DEMO; " C-M
tmux send-keys "create table DEMO.HIST as select rownum id,decode(rownum,100,'Y','N') flag from xmltable('1 to 10000'); " C-M
tmux send-keys "create index DEMO.HIST_FLAG on DEMO.HIST(flag); " C-M
tmux send-keys "exec dbms_stats.set_table_prefs('DEMO','HIST','publish','true'); " C-M
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST',method_opt=>'for all columns size skewonly'); " C-M
tmux send-keys "exec dbms_stats.set_global_prefs('TRACE',0); " C-M

tmux send-keys "exec dbms_stats.delete_system_stats; " C-M


tmux send-keys "exec DBMS_STATS.DROP_ADVISOR_TASK('my_task1'); " C-M
tmux send-keys "set linesize 100 trimspool on long 1000000 longc 10000" C-M
tmux send-keys "column R format a100" C-M

tmux send-keys "print" C-M
tmux send-keys "alter session set statistics_level=all; " C-M
tmux send-keys "alter session set nls_date_format='dd-mon-yy hh24:mi:ss'; " C-M
tmux send-keys "set serveroutput off define off; " C-M
tmux send-keys "set sqlformat ansiconsole" C-M
tmux send-keys "select pname,pval1,calculated,formula from sys.aux_stats"'$'" where sname='SYSSTATS_MAIN'" C-M "model" C-M "  reference sga on (" C-M "    select name,value from v"'$'"sga " C-M "        ) dimension by (name) measures(value)" C-M "  reference parameter on (" C-M "    select name,decode(type,3,to_number(value)) value from v"'$'"parameter where name='db_file_multiblock_read_count' and ismodified!='FALSE'" C-M "    union all" C-M "    select name,decode(type,3,to_number(value)) value from v"'$'"parameter where name='sessions'" C-M "    union all" C-M "    select name,decode(type,3,to_number(value)) value from v"'$'"parameter where name='db_block_size'" C-M "        ) dimension by (name) measures(value)" C-M "partition by (sname) dimension by (pname) measures (pval1,pval2,cast(null as number) as calculated,cast(null as varchar2(60)) as formula) rules(" C-M "  calculated['MBRC']=coalesce(pval1['MBRC'],parameter.value['db_file_multiblock_read_count'],parameter.value['_db_file_optimizer_read_count'],8)," C-M "  calculated['MREADTIM']=coalesce(pval1['MREADTIM'],pval1['IOSEEKTIM'] + (parameter.value['db_block_size'] * calculated['MBRC'] ) / pval1['IOTFRSPEED'])," C-M "  calculated['SREADTIM']=coalesce(pval1['SREADTIM'],pval1['IOSEEKTIM'] + parameter.value['db_block_size'] / pval1['IOTFRSPEED'])," C-M "  calculated['   multi block Cost per block']=round(1/calculated['MBRC']*calculated['MREADTIM']/calculated['SREADTIM'],4)," C-M "  calculated['   single block Cost per block']=1," C-M "  formula['MBRC']=case when pval1['MBRC'] is not null then 'MBRC' when parameter.value['db_file_multiblock_read_count'] is not null then 'db_file_multiblock_read_count' when parameter.value['_db_file_optimizer_read_count'] is not null then '_db_file_optimizer_read_count' else '= _db_file_optimizer_read_count' end," C-M "  formula['MREADTIM']=case when pval1['MREADTIM'] is null then '= IOSEEKTIM + db_block_size * MBRC / IOTFRSPEED' end," C-M "  formula['SREADTIM']=case when pval1['SREADTIM'] is null then '= IOSEEKTIM + db_block_size        / IOTFRSPEED' end," C-M "  formula['   multi block Cost per block']='= 1/MBRC * MREADTIM/SREADTIM'," C-M "  formula['   single block Cost per block']='by definition'," C-M "  calculated['   maximum mbrc']=round(sga.value['Database Buffers']/(parameter.value['db_block_size']*parameter.value['sessions']))," C-M "  formula['   maximum mbrc']='= buffer cache size in blocks / sessions'" C-M ")" C-M "/" C-M "save /tmp/aux_stats.sql replace" C-M
tmux send-keys "exec DBMS_STATS.DROP_ADVISOR_TASK('my_task2'); " C-M

--- ##################################################################
---  F12
--- ##################################################################

tmux send-keys "set sqlformat ansiconsole" C-M

--- ##################################################################
---  stale statistics
--- ##################################################################
tmux send-keys C-M

tmux send-keys "create table DEMO.DEMO(day date); " C-M
tmux send-keys "insert into DEMO.DEMO select trunc(date'2016-01-01'+(rownum-1)/100) from xmltable('1 to 36600'); " C-M
---  --> hundred of rows every for one year
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','DEMO')" C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO; " C-M

--- # I query the last date
tmux send-keys "alter session set statistics_level=all; " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2016-12-31'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
--- --> good estimation

---  I insert a new day
tmux send-keys "insert into DEMO.DEMO select date '2017-01-01' from xmltable('1 to 100'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2017-01-01'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
--- --> still good estimation (didn't gather stats)

tmux send-keys "insert into DEMO.DEMO select date '2017-01-02' from xmltable('1 to 100'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2017-01-02'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
--- --> with one more day, estimation decreases

tmux send-keys "insert into DEMO.DEMO select trunc(date'2017-01-03'+(rownum-1)/100) from xmltable('1 to 3100'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2017-02-02'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
--- --> after one month it becomes worse

tmux send-keys "insert into DEMO.DEMO select trunc(date'2017-02-03'+(rownum-1)/100) from xmltable('1 to 33300'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2018-01-01'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
--- --> after one year misestimate can lead to very bad execution plans


--- ##################################################################
---  Statistics History
--- ##################################################################
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST',method_opt=>'for all columns size skewonly'); " C-M
tmux send-keys "host clear" C-M


---  I get the date.
tmux send-keys "select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual; " C-M

---  I gather statistics
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST'); " C-M
---  I have a table and query that is ok
tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
--- --> bad estimation. I want to revert back to before stats gathering

tmux send-keys "set autotrace off long 10000 longc 10000 " C-M
tmux send-keys "select report from table(" C-M
tmux send-keys " dbms_stats.diff_table_stats_in_history(" C-M
tmux send-keys "'DEMO','HIST', timestamp'" 
tmux copy-mode ; tmux send-key -X search-backward "TO_CHAR(SYSDATE,'YY" ; tmux send-key -X cursor-down ; tmux send-key -X begin-selection ; tmux send-keys -X end-of-line ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel
tmux paste-buffer 
tmux send-keys "',current_timestamp,pctthreshold=>10" C-M
tmux send-keys " )" C-M
tmux send-keys "); " C-M ; sleep 1
--- --> I see the difference: histograms

tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M

tmux send-keys "exec dbms_stats.restore_table_stats('DEMO','HIST',as_of_timestamp=>timestamp'" 
tmux copy-mode ; tmux send-key -X search-backward "TO_CHAR(SYSDATE,'YY" ; tmux send-key -X cursor-down ; tmux send-key -X begin-selection ; tmux send-keys -X end-of-line ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel
tmux paste-buffer 
tmux send-keys "',no_invalidate=>false); " C-M

tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M

tmux send-keys "select dbms_stats.get_stats_history_retention from dual; " C-M

--- ##################################################################
---  Pending Statistics
--- ##################################################################
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST',method_opt=>'for all columns size skewonly'); " C-M
tmux send-keys "host clear" C-M

tmux send-keys "exec dbms_stats.set_table_prefs('DEMO','HIST','publish','false'); " C-M
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST',method_opt=>'for all columns size 1',no_invalidate=>false); " C-M
tmux send-keys "alter session set optimizer_use_pending_statistics=true; " C-M
tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys "alter session set optimizer_use_pending_statistics=false; " C-M
tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys "exec dbms_stats.delete_pending_stats('DEMO','HIST'); " C-M
tmux send-keys "exec dbms_stats.set_table_prefs('DEMO','HIST','publish','true'); " C-M

--- ##################################################################
---  Histograms and bind variables
--- ##################################################################
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST',method_opt=>'for all columns size skewonly'); " C-M
tmux send-keys "host clear" C-M

tmux send-keys "variable flag char(1) " C-M
tmux send-keys "exec :flag:='Y' " C-M
tmux send-keys "select count(id) from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys "exec :flag:='N' " C-M
tmux send-keys "select count(id) from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
---  run it again 
tmux send-keys "select count(id) from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
--- --> Adaptive Cursor Sharing

--- #tmux send-keys 'alter session set "_optimizer_use_histograms"=false; ' C-M
--- #tmux send-keys "select count(id) n from DEMO.HIST where flag=:flag; " C-M
--- #tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys 'alter session set "_optim_peek_user_binds"=false; ' C-M
tmux send-keys "select count(id) n from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M


--- ##################################################################
---  Session Statistics (GTT)
--- ##################################################################

tmux send-keys "connect demo/demo@//localhost/pdb1 " C-M
tmux send-keys "host clear" C-M

tmux send-keys "create global temporary table DEMO_GTT(n number) on commit preserve rows; " C-M
tmux send-keys "connect demo/demo@//localhost/pdb1 " C-M
tmux send-keys "insert into DEMO_GTT select rownum from dual connect by level<=1; " C-M
tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys 'select sql_id,child_number,executions,invalidations,reason from v$sql join v$sql_shared_cursor using(sql_id,child_number)' "where sql_id='" 
tmux copy-mode ; tmux send-key -X search-backward "SQL_ID" ; tmux send-key -N2 -X next-word ; tmux send-key -X begin-selection ; tmux send-keys -X next-word-end ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel
tmux paste-buffer ; tmux send-keys "'; " C-M

tmux send-keys "connect demo/demo@//localhost/pdb1 " C-M
tmux send-keys "insert into DEMO_GTT select rownum from dual connect by level<=1000; " C-M
tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys 'select sql_id,child_number,executions,invalidations,reason from v$sql join v$sql_shared_cursor using(sql_id,child_number)' "where sql_id='" 
tmux copy-mode ; tmux send-key -X search-backward "SQL_ID" ; tmux send-key -N2 -X next-word ; tmux send-key -X begin-selection ; tmux send-keys -X next-word-end ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel
tmux paste-buffer ; tmux send-keys "'; " C-M


tmux send-keys "select dbms_stats.get_prefs('GLOBAL_TEMP_TABLE_STATS') from dual; " C-M
tmux send-keys "exec dbms_stats.gather_table_stats(user,'DEMO_GTT',options=>'GATHER AUTO',no_invalidate=>true); " C-M
tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys 'select sql_id,child_number,executions,invalidations,reason from v$sql join v$sql_shared_cursor using(sql_id,child_number)' "where sql_id='" 
tmux copy-mode ; tmux send-key -X search-backward "SQL_ID" ; tmux send-key -N2 -X next-word ; tmux send-key -X begin-selection ; tmux send-keys -X next-word-end ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel
tmux paste-buffer ; tmux send-keys "'; " C-M

---	tmux split-window -l 20 "ssh oracle@${HOST:-192.168.56.188}"
---	tmux send-keys "sqlplus demo/demo@//localhost/PDB; " C-M
---
---	tmux send-keys "insert into DEMO_GTT select rownum from dual connect by level<=1000; " C-M
---	tmux send-keys "exec dbms_stats.gather_table_stats(user,'DEMO_GTT',no_invalidate=>true); " C-M
---	tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
---	tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>' iostats last')); " C-M






--- ##################################################################
---  set statistics
--- ##################################################################

tmux send-keys "connect demo/demo@//localhost/pdb1 " C-M
tmux send-keys "exec dbms_stats.set_table_prefs(user,'DEMO_GTT','GLOBAL_TEMP_TABLE_STATS','SHARED'); " C-M
tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys "exec dbms_stats.set_table_stats(user,'DEMO_GTT',numrows=>1e6,no_invalidate=>false); " C-M
tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M


--- ##################################################################
---  fixed statistics
--- ##################################################################

--- ##################################################################
---  system statistics
--- ##################################################################


--- #tmux send-keys "set serverout on define off; " C-M
--- #tmux send-keys "exec dbms_stats.set_global_prefs('TRACE',0); " C-M
--- #tmux send-keys "exec dbms_stats.set_global_prefs('TRACE',1048575); " C-M
tmux send-keys "alter system flush buffer_cache; " C-M
tmux send-keys "exec dbms_stats.delete_system_stats; " C-M
tmux send-keys "@/tmp/aux_stats" C-M
tmux send-keys "exec dbms_stats.gather_system_stats; " C-M
tmux send-keys "@/tmp/aux_stats" C-M
tmux send-keys "exec dbms_stats.gather_system_stats('start'); " C-M
tmux send-keys "drop table demo; " C-M
tmux send-keys "create table demo as select * from dba_objects; " C-M
tmux send-keys "create index demo on demo(object_id); " C-M
tmux send-keys "delete from demo; " C-M
tmux send-keys "drop table demo; " C-M
tmux send-keys "exec dbms_stats.gather_system_stats('stop'); " C-M
tmux send-keys "@/tmp/aux_stats" C-M
tmux send-keys "exec dbms_stats.gather_system_stats('exadata'); " C-M
tmux send-keys "@/tmp/aux_stats" C-M
tmux send-keys "exec dbms_stats.delete_system_stats; " C-M



--- ##################################################################
---  Optimizer Statsistics Advisor
--- ##################################################################

--- #tmux send-keys "exec DBMS_STATS.DROP_ADVISOR_TASK('my_task2'); " C-M
tmux send-keys "variable t varchar2(10)" C-M
tmux send-keys "exec :t:= DBMS_STATS.CREATE_ADVISOR_TASK('my_task2'); " C-M
tmux send-keys "variable e varchar2(10)" C-M
tmux send-keys "exec :e:= DBMS_STATS.EXECUTE_ADVISOR_TASK('my_task2'); " C-M
tmux send-keys C-C
tmux send-keys "variable r clob" C-M
tmux send-keys "exec :r:= DBMS_STATS.REPORT_ADVISOR_TASK('my_task2'); " C-M
tmux send-keys "set linesize 100 trimspool on long 1000000 longc 10000" C-M
tmux send-keys "column R format a100" C-M
tmux send-keys "print" C-M
tmux send-keys "select to_char(rule_id,99)||' '||description||' ('||name||')' " 'from V$STATS_ADVISOR_RULES where rule_id>0 order by rule_id; ' C-M
tmux send-keys "exec DBMS_STATS.DROP_ADVISOR_TASK('my_task2'); " C-M


--- ##################################################################
---  END (Bonus) 12:30 - 13:20
--- ##################################################################

--- ##################################################################
---  Automatic statistics collection
--- ##################################################################

tmux send-keys "select window_name,window_next_time,autotask_status,optimizer_stats from DBA_AUTOTASK_WINDOW_CLIENTS; " C-M
tmux send-keys "select window_name,window_start_time,window_end_time from DBA_AUTOTASK_WINDOW_HISTORY order by 2 desc fetch first 5 rows only; " C-M
--- --> maintenance window is created and enabled
tmux send-keys "select client_name,status from DBA_AUTOTASK_CLIENT where client_name='auto optimizer stats collection'; " C-M
tmux send-keys "select task_name,status,last_good_date,last_try_date from DBA_AUTOTASK_TASK where client_name='auto optimizer stats collection'; " C-M
--- --> statistic collection maintenance task is enabled
show parameter job

tmux send-keys "--" C-M

--- ##################################################################
---  XXXXXXXXXXXXXXXXX
--- ##################################################################


 TRACE_LEVEL NUMBER;
  DSC_DBMS_OUTPUT_TRC CONSTANT NUMBER := 1;

  DSC_SESSION_TRC  CONSTANT NUMBER := 2;
  DSC_TAB_TRC  CONSTANT NUMBER := 4;
  DSC_IND_TRC  CONSTANT NUMBER := 8;
  DSC_COL_TRC  CONSTANT NUMBER := 16;
  DSC_AUTOST_TRC  CONSTANT NUMBER := 32;
  DSC_SCALING_TRC  CONSTANT NUMBER := 64;
  DSC_ERROR_TRC  CONSTANT NUMBER := 128;
  DSC_DUBIOUS_TRC  CONSTANT NUMBER := 256;
  DSC_AUTOJOB_TRC CONSTANT NUMBER := 512;
  DSC_PX_TRC  CONSTANT NUMBER := 1024;
  DSC_Q_TRC  CONSTANT NUMBER := 2048;
  DSC_CCT_TRC  CONSTANT NUMBER := 4096;
  DSC_DIFFST_TRC  CONSTANT NUMBER := 8192;
  DSC_USTATS_TRC CONSTANT NUMBER := 16384;
  DSC_SYN_TRC CONSTANT NUMBER := 32768;
  DSC_ONLINE_TRC CONSTANT NUMBER := 65536;
  DSC_ADOP_TRC CONSTANT NUMBER := 131072;
  DSC_SYSSTATS_TRC CONSTANT NUMBER := 262144;
  DSC_ADVISOR_TRC CONSTANT NUMBER := 524288;

