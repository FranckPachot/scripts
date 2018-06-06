--- tmux display-message "testing ping to server..." 
--- ping -w 5000 -n 1 ${HOST:-192.168.56.188} || exit
--- tmux display-message "server ok."
--- 
--- tmux kill-window -t "JoinMethods"
--- tmux new-window -k -n "JoinMethods" 
--- sleep 1
--- tmux send-keys "ssh oracle@${HOST:-192.168.56.188}" C-M
--- tmux display-message "wait for tmux window..."
--- sleep 1
--- 
--- ####################################################################################
--- ############################## begin sqlcl env #####################################
--- #tmux send-keys "echo set sqlformat ansiconsole > /tmp/login.sql " C-M
--- #tmux send-keys "alias sql='SQLPATH=/tmp JAVA_HOME="'$ORACLE_HOME/jdk bash $ORACLE_HOME'"/sqldeveloper/sqlcl/bin/sql -l'" C-M
--- #tmux send-keys '[ -r /media/sf_Soft/sqlcl/bin/sql ] &&' "alias sql='SQLPATH=/tmp JAVA_HOME="'$ORACLE_HOME/jdk bash '"/media/sf_Soft/sqlcl/bin/sql -l'" C-M
--- #tmux send-keys "rm -f login.sql" C-M
--- #tmux send-keys "reset" C-M
--- #sleep 1
--- ####################################################################################
--- 
--- tmux send-keys -t :.0 "TWO_TASK=//localhost/CDB1${DOMAIN} sqlplus sys/oracle as sysdba <<< 'alter pluggable database PDB1 open; ' " C-M
--- tmux send-keys -t :.0 "TWO_TASK=//localhost/CDB1${DOMAIN} rman target sys/oracle <<< 'delete noprompt archivelog all; ' " C-M
--- tmux send-keys -t :.0 "TWO_TASK=//localhost/PDB1${DOMAIN} sqlplus sys/oracle as sysdba @ ?/rdbms/admin/utlsampl" </dev/null C-M
--- tmux send-keys -t :.0 "echo | TWO_TASK=//localhost/PDB1${DOMAIN} sqlplus sys/oracle as sysdba @ ?/rdbms/admin/userlock" C-M
--- tmux send-keys -t :.0 "TWO_TASK=//localhost/PDB1${DOMAIN} sqlplus sys/oracle as sysdba <<<'grant dba to scott;'" C-M
--- tmux send-keys -t :.0 "sql scott/tiger@//localhost/PDB1${DOMAIN}" C-M
--- sleep 2



set linesize 120 pagesize 1000
set long 1000000 longc 1000 linesize 200
column xml format a120
column json format a120
drop table EMP2 purge;
alter table EMP no inmemory;
alter table DEPT no inmemory;
alter table EMP modify constraint FK_DEPTNO enable validate;
exec dbms_stats.gather_schema_stats(user);
alter session set statistics_level=all;
set sqlformat default
alter session set statistics_level=all;
alter system set shared_pool_size=400M;
select /*+ leading(DEPT) USE_HASH(EMP) no_swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno);
select /*+ leading(DEPT) USE_HASH(EMP) no_swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno);
select /*+ leading(DEPT) USE_HASH(EMP) swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno);
select /*+ leading(DEPT) USE_MERGE(EMP) FULL(DEPT) monitor */ * from DEPT join EMP using(deptno);

-- https://mauro-pagano.com/2017/07/30/sql-diag-repository/
alter session set "_sql_diag_repo_retain" = true "_sql_diag_repo_origin"=all;

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
-- Here is the font I'll use for the demo, so please move in front ;)
--


--- #F12 until there



--- #------------------------------- finally start there

select deptno,dname from dept order by 1; 
select empno,ename,job,hiredate,deptno from emp order by 1; 
select * from DEPT join EMP using(deptno)
/

--- # visualize ( gdb function method )
--- tmux select-pane -t :.0
quit
--- tmux send-keys -t :.0 "sqlplus scott/tiger@//localhost/PDB1${DOMAIN}" C-M
set linesize 120 pagesize 3 arraysize 1
--- tmux kill-pane -t :.1 
--- tmux split-window -l 30 "ssh oracle@${HOST:-192.168.56.188}"
--- tmux send-keys -t :.1 "sql sys/oracle@//localhost/PDB1${DOMAIN} as sysdba" C-M
--- tmux select-pane -t :.1
set long 100000 longc 1000 
set sqlformat ansiconsole
select /*+ monitor */ * from dual;
select regexp_replace(dbms_sqltune.report_sql_monitor(sql_id=>sql_id,report_level=>'all',event_detail=>'NO',type=>'text'),'^(.{120}).*$','\1',1,0,'m') from v$sql_monitor where service_name =sys_context('userenv','service_name') order by last_refresh_time desc fetch first 1 rows only;
format buffer

--- tmux send-keys "repeat 1200 1"
--- tmux send-keys C-M

--- tmux select-pane -t :.0
set arraysize 1
select /*+ leading(DEPT) USE_NL(EMP) monitor */ * from DEPT join EMP using(deptno)
/
select /*+ leading(DEPT) USE_HASH(EMP) no_swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno)
/
select /*+ leading(DEPT) USE_HASH(EMP) swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno)
/
select /*+ leading(DEPT) USE_MERGE(EMP) FULL(DEPT) monitor */ * from DEPT join EMP using(deptno)
/
select /*+ leading(DEPT) USE_MERGE_CARTESIAN(EMP) monitor */ * from DEPT cross join EMP 
/


--- tmux select-pane -t :.0
select spid from v$process join v$session on v$session.paddr=v$process.addr where sid=sys_context('userenv','sid');
--- tmux copy-mode ; tmux send-key -X search-backward "SPID" ; tmux send-key -X cursor-down ; tmux send-key -X cursor-down ; tmux send-key -X begin-selection ; tmux send-keys -X end-of-line ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel
--- # QER stands for Query Execution Rowsource
--- tmux split-window -t :.1 "ssh oracle@${HOST:-192.168.56.188}"
--- tmux select-pane -t :.2
--- tmux send-key "gdb -p " ; tmux paste-buffer 
--- tmux send-key C-M
--- tmux select-pane -t :.2                             # Query Execution Rowsource
--- tmux send-keys "break opifch2" C-M			# SELECT STATEMENT	fetch call
--- tmux send-keys "break qertbAllocate" C-M		# TABLE ACCESS FULL
--- tmux send-keys "break qertbStart" C-M		# exec
--- tmux send-keys "break qertbFetch" C-M		# fetch
--- tmux send-keys "break qertbFetchByRowID" C-M	# 
--- tmux send-keys "break qertbClose" C-M		# close
--- tmux send-keys "break qerixAllocate" C-M		# INDEX ACCESS
--- tmux send-keys "break qerixStart" C-M		# exec
--- tmux send-keys "break qerixGetKey" C-M
--- tmux send-keys "break qerixtFetch" C-M
--- tmux send-keys "break qerixGetRowid" C-M
--- tmux send-keys "break qerixRelease" C-M
--- tmux send-keys "break qerixClose" C-M
--- tmux send-keys "break qerjoAllocate" C-M		# NESTED LOOP, MERGE JOIN
--- tmux send-keys "break qerjoStart" C-M		# exec
--- tmux send-keys "break qerjotFetch" C-M		# fetch
--- tmux send-keys "break qerjotRelease" C-M		# return
--- tmux send-keys "break qerjotRowProc" C-M		# next outer row
--- tmux send-keys "break qerjoRowProcedure" C-M	# 
--- tmux send-keys "break qerjoClose" C-M		# close
--- tmux send-keys "break qerhjAllocate" C-M		# HASH JOIN
--- tmux send-keys "break qerhnStart" C-M		# exec
--- tmux send-keys "break qerhnFetch" C-M		# fetch
--- tmux send-keys "break qerhn_kxhrPack" C-M		# one per build row
--- tmux send-keys "break qerhnBuildHashTable" C-M	# build hash from build rows
--- tmux send-keys "break qerhnAllocHashTable" C-M	# alloc
--- tmux send-keys "break qerhnProbeChooseRowP" C-M	# starting probe
--- tmux send-keys "break qerhnClose" C-M		# close
--- tmux send-keys "break qersoAllocate" C-M		# BUFFER SORT
--- tmux send-keys "break qersoStart" C-M		# exec
--- tmux send-keys "break qersoFetchSimple" C-M		#
--- tmux send-keys "break qersoFetch" C-M		#
--- tmux send-keys "break qersoSORowP" C-M		# one per row to be sorted
--- tmux send-keys "break qersoFKeyCompare" C-M		# merge on the two buffers
--- tmux send-keys "break qersoClose" C-M		# close
--- tmux send-keys "break qergsAllocate" C-M		#
--- tmux send-keys "break qergsStart" C-M		#
--- tmux send-keys "break qergsRowP" C-M
--- tmux send-keys "break qergsFetch" C-M
--- tmux send-keys "break qergsRelease" C-M
--- tmux send-keys "break qergsClose" C-M
--- tmux send-keys "break qerscAllocate" C-M		# STATISTIC COLLECTOR
--- tmux send-keys "break qerscStart" C-M
--- tmux send-keys "break qerscFetch" C-M
--- tmux send-keys "break qerscDisableGatherStats" C-M
--- tmux send-keys "break qerscAggStatsAndFireActions" C-M
--- tmux send-keys "break qerscDisableGatherStats" C-M
--- tmux send-keys "break qerscFetchBuffer" C-M
--- tmux send-keys "break qerscFireActions" C-M
--- tmux send-keys "break qerscRelease" C-M
--- tmux send-keys "break qerscClose" C-M
--- tmux send-keys "break qerjoDisableNLJCbk" C-M
--- tmux send-keys "break qerhjDisableHJCbk" C-M
--- tmux send-keys "break qerjoDisableNLJRws" C-M
--- #
--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_NL(EMP) monitor */ * from DEPT join EMP using(deptno);
--- tmux select-pane -t :.2
c

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_HASH(EMP) no_swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno);
--- tmux select-pane -t :.2
c

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_HASH(EMP) swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno);
--- tmux select-pane -t :.2
c

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_MERGE(EMP) FULL(DEPT) monitor */ * from DEPT join EMP using(deptno);
--- tmux select-pane -t :.2
c

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_MERGE_CARTESIAN(EMP) monitor */ * from DEPT cross join EMP ;
--- tmux select-pane -t :.2
c

disable
cont
--- tmux send-key C-C
enable

--- tmux select-pane -t :.0
select /*+ monitor */ * from DEPT join EMP using(DEPTNO) where to_char(SAL)like'%0';
--- tmux select-pane -t :.2
c

--- tmux select-pane -t :.2
delete
y
cont
--- tmux send-key C-C
quit
y



--- #------------------------------- back to the slides

--- # adaptive

--- tmux select-pane -t :.0
alter system flush shared_pool;
alter session set statistics_level=all;
set pagesize 1000 linesize 130
explain plan for select /*+ monitor */ * from DEPT join EMP using(DEPTNO) where to_char(SAL)like'%0';
select * from dbms_xplan.display(format=>'+adaptive');
--- tmux resize-pane -Z -t :.0
--- tmux resize-pane -Z -t :.0
select /*+ monitor */ * from DEPT join EMP using(DEPTNO) where to_char(SAL)like'%0';
select * from dbms_xplan.display_cursor(format=>'+adaptive allstats last'); 
--- tmux resize-pane -Z -t :.0
--- tmux resize-pane -Z -t :.0

--- tmux select-pane -t :.0
column tracefile new_value tracefile
alter session set tracefile_identifier='cbo_trace';
select tracefile from v$process where addr=(select paddr from v$session where sid=sys_context('userenv','sid'));
--- tmux send-keys "host > &tracefile." C-M
exec dbms_sqldiag.dump_trace(p_sql_id=>'bpmj48yjg09k4',p_child_number=>0,p_component=>'Compiler',p_file_id=>'');
--- tmux send-keys 'host grep -E --color=auto "^(DP.*|AP)" &tracefile.' 


--- # join elimination

--- tmux select-pane -t :.0
set pagesize 1000 linesize 120
select /*+ monitor */ DEPTNO,ENAME,SAL from DEPT join EMP using(DEPTNO);
l
select * from dbms_xplan.display_cursor(format=>'+outline +report')
/

--- bypass that
select sql_id,plan_id,child_number,state,reason,feature,(select description from v$sql_feature where sql_feature = feature) feature
from v$sql_diag_repository p join v$sql_diag_repository_reason s using (sql_diag_repo_id,sql_id,feature,con_id,hash_value,child_number,address)
where sql_id='9a0nt1xmg0f3q' order by decode(state,'bypass','disabled','enabled') desc;


--- tmux resize-pane -Z -t :.0
--- tmux resize-pane -Z -t :.0
alter table EMP modify constraint FK_DEPTNO disable;
select /*+ monitor */ DEPTNO,ENAME,SAL from DEPT join EMP using(DEPTNO); 
l
alter table EMP modify constraint FK_DEPTNO rely;
select /*+ monitor */ DEPTNO,ENAME,SAL from DEPT join EMP using(DEPTNO); 
l
show parameter query_rewrite
alter session set query_rewrite_integrity=trusted;
select /*+ monitor */ DEPTNO,ENAME,SAL from DEPT join EMP using(DEPTNO); 
l
select * from dbms_xplan.display_cursor(format=>'')
/

--- # partition wise join
set pagesize 1000 linesize 120
alter table DEPT modify partition by hash(LOC) partitions 8 online;
alter table EMP modify DEPTNO not null;
alter table EMP modify partition by reference(FK_DEPTNO) ;
alter table EMP modify constraint FK_DEPTNO enable validate;
alter table EMP modify partition by reference(FK_DEPTNO) ;
select /*+ monitor leading(DEPT) use_hash(EMP) */ * from DEPT join EMP using(DEPTNO) 
/
select * from dbms_xplan.display_cursor(format=>'+outline');


--- #-------------------------- back to slides
--- # SYNTAX                                     
--- tmux resize-pane -Z -t :.0
spool qkajoi_froPUjoi1.txt
host TWO_TASK=//localhost/PDB1${DOMAIN} sqlplus sys/oracle as sysdba @ ?/rdbms/admin/utlsampl

--- # cartesian join
select E.job,E.empno,E.ename,E.hiredate,E.deptno,D.deptno,D.dname 
from DEPT D,EMP E
.
/
select E.job,E.empno,E.ename,E.hiredate,E.deptno,D.deptno,D.dname 
from DEPT D,EMP E
where D.deptno=E.deptno
/
select E.job,E.empno,E.ename,E.hiredate,D.deptno,D.dname 
from DEPT D inner join EMP E on(D.deptno=E.deptno)
/
select E.job,E.empno,E.ename,E.hiredate,deptno,D.dname 
from DEPT D inner join EMP E using(deptno)
/
select E.job,E.empno,E.ename,E.hiredate,deptno,D.dname 
from DEPT D natural inner join EMP E 
/

select job,empno,ename,hiredate,deptno,dname 
from 
 (select deptno,dname from DEPT)
natural inner join 
 (select deptno,ename,job,empno,hiredate from EMP E )
/

-- # semi and anti joins
select * from dbms_xplan.display_cursor()
/

select deptno,dname
from DEPT D where exists ( select 'x' from EMP E where D.deptno=E.deptno )
/
select * from dbms_xplan.display_cursor()
/
select deptno,dname
from DEPT D where not exists ( select 'x' from EMP E where D.deptno=E.deptno )
/
select * from dbms_xplan.display_cursor()
/

--- # outer join

select D.dname,deptno,E.job,E.empno,E.ename,E.hiredate
from DEPT D left join EMP E using(deptno)
order by 2,3
/

--- #I want one line for each possible job in the department
select D.dname,deptno,E.job,E.empno,E.ename,E.hiredate
from DEPT D left outer join EMP E partition by (e.job) using(deptno)
order by 2,3
/

--- bug???

rename EMP to EMP2;
create table EMP as select * from EMP2;

select D.dname,deptno,E.job,E.empno,E.ename,E.hiredate
from DEPT D left join EMP E using(deptno)
order by 2,3
/
select D.dname,deptno,E.job,E.empno,E.ename,E.hiredate
from DEPT D left outer join EMP E partition by (e.job) using(deptno)
order by 2,3
/









--# theta-joins vs. equi-joins

select D1.LOC,E1.ENAME,E1.SAL,D2.LOC,E2.ENAME,E2.SAL
 from DEPT D1 
 join EMP E1 on D1.DEPTNO=E1.DEPTNO
 join EMP E2 on E1.SAL=E2.SAL
 join DEPT D2 on D2.DEPTNO=E2.DEPTNO
 where D1.DEPTNO=10
   and D2.DEPTNO=20;

select * from dbms_xplan.display_cursor(format=>'iostats last')
/

select D1.LOC,E1.ENAME,E1.SAL,D2.LOC,E2.ENAME,E2.SAL
 from DEPT D1 
 join EMP E1 on D1.DEPTNO=E1.DEPTNO
 join EMP E2 on E1.SAL>=E2.SAL
 join DEPT D2 on D2.DEPTNO=E2.DEPTNO
 where D1.DEPTNO=10
   and D2.DEPTNO=20;

select * from dbms_xplan.display_cursor(format=>'iostats last')
/

--# bushy join

connect sys/oracle@//localhost/PDB1 as sysdba
select ksppinm,ksppstdvl,ksppstdvl,ksppdesc from sys.x$ksppi join sys.x$ksppcv using(indx) where ksppinm like '%bush%';
connect scott/tiger@//localhost/PDB1
alter session set statistics_level=all;

select /*+ BUSHY_JOIN((D1 E1)(D2 E2)) */ D1.LOC,E1.ENAME,E1.SAL,D2.LOC,E2.ENAME,E2.SAL
 from DEPT D1 
 join EMP E1 on D1.DEPTNO=E1.DEPTNO
 join EMP E2 on E1.SAL=E2.SAL
 join DEPT D2 on D2.DEPTNO=E2.DEPTNO
 where D1.DEPTNO=10
   and D2.DEPTNO=20;

select * from dbms_xplan.display_cursor(format=>'iostats last')
/



--- ### --- first demo

--- #you know that in relational databases we store business entities in separate tables and we join them at runtime

--- #were are working on relational tables
select deptno,dname from dept order by 1; 
select empno,ename,job,hiredate,deptno from emp order by 1; 

--- #but when you query them you need a hierachical view

--- #employees by department
break on deptno on dname on job noduplicates
select deptno,dname,job,empno,ename from DEPT join EMP using(deptno) order by deptno,job
/
--- #employees by job

break on job noduplicates
select job,empno,ename,hiredate,deptno,dname from DEPT join EMP using(deptno) order by job
/

--- # this is relational databases. 50 years. history. before hierarchival
--- #because the hierarchy is not stored but build at execution time with joins

select * from dbms_xplan.display_cursor()
/

--- #Today, XML and JSON are hierarchical. Some people wants to store it hierarchical, but that's going back to technology from 50 years ago. You can do it with relational

clear breaks
set sqlformat ansiconsole

select xmlserialize(document
 xmlelement("Departments",
  xmlelement("Department",
   xmlattributes(
    DEPTNO as "deptno", 
    DNAME as "dname"
   ),
   xmlagg(
    xmlelement("Employees", xmlattributes(
      EMPNO as "empno",
      ENAME as "ename"
     )
    )
   )
  )
 )
as clob indent size=2) as xml
from emp join dept using(deptno)
group by deptno,dname order by deptno
/

--- #today XML is not cool anymore so we do json

select
 json_query(
   json_object(
    'deptno' value DEPTNO,
    'dname' value DNAME,
    'Employees' value json_arrayagg(
      json_object(
       'empno' value empno, 
       'ename' value ename
     ) 
    )
   ) 
 ,'$[0]' pretty) JSON
from emp join dept using(deptno) 
group by deptno,dname order by deptno desc
/

select * from dbms_xplan.display_cursor()
/

--- #so if you want to use your data for more than one thing, better use relational databases














--- #end ------------------------------------------- 




--- # visualize ( slow function method )

quit
--- tmux send-keys -t :.0 "sqlplus scott/tiger@//localhost/PDB1${DOMAIN}" C-M
set linesize 120 pagesize 3 arraysize 1
--- tmux kill-pane -t :.1 
--- tmux split-window -l 30 "ssh oracle@${HOST:-192.168.56.188}"
--- tmux send-keys -t :.1 "sql sys/oracle@//localhost/PDB1${DOMAIN} as sysdba" C-M

--- tmux select-pane -t :.0
create or replace function slow(n varchar2,s number) return number as 
 begin user_lock.sleep(100*s); return 1; end;
/
set arraysize 1
--- tmux select-pane -t :.1
set long 100000 longc 1000 
set sqlformat ansiconsole
select /*+ monitor */ * from dual;
select regexp_replace(dbms_sqltune.report_sql_monitor(sql_id=>sql_id,report_level=>'all',event_detail=>'NO',type=>'text'),'^(.{120}).*$','\1',1,0,'m') from v$sql_monitor where service_name =sys_context('userenv','service_name') order by last_refresh_time desc fetch first 1 rows only;
l
--- tmux send-keys "repeat 1200 1"
--- tmux send-keys C-M

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_NL(EMP) monitor */ * from DEPT join EMP using(deptno)
where slow(DEPT.LOC,4)>0 and slow(EMP.COMM,1)>0
/

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_HASH(EMP) no_swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno)
where slow(DEPT.LOC,4)>0 and slow(EMP.COMM,1)>0
/

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_HASH(EMP) swap_join_inputs(EMP) monitor */ * from DEPT join EMP using(deptno)
where slow(DEPT.LOC,4)>0 and slow(EMP.COMM,1)>0
/

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_MERGE(EMP) FULL(DEPT) monitor */ * from DEPT join EMP using(deptno)
where slow(DEPT.LOC,4)>0 and slow(EMP.COMM,2)>0
/

--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_MERGE_CARTESIAN(EMP) monitor */ * from DEPT cross join EMP 
where slow(DEPT.LOC,4)>0 and slow(EMP.COMM,1)>0
/




--# parallel

--- tmux select-pane -t :.0
alter session force parallel query parallel 4;
select /*+ monitor leading(DEPT) use_hash(EMP) */ * from DEPT join EMP using(DEPTNO) 
where slow(EMP.COMM,1)>0
/

--# in-memory

--- tmux select-pane -t :.0
alter table EMP inmemory priority high;
alter table DEPT inmemory priority high;
alter session set "_inmemory_populate_wait"=true;
select /*+ monitor full(emp) full(dept) */ DNAME,sum(SAL) from DEPT join EMP using(DEPTNO) group by DNAME
/
select * from dbms_xplan.display_cursor(format=>'+outline');



--- tmux select-pane -t :.0
explain plan for select /*+ leading(DEPT) USE_NL(EMP) */ * from DEPT join EMP using(deptno);
select * from dbms_xplan.display(format=>'typical -predicate');
explain plan for select /*+ leading(DEPT) USE_NL(EMP) cardinality(DEPT 1000) */ * from DEPT join EMP using(deptno);
select * from dbms_xplan.display(format=>'typical -predicate');
--- tmux select-pane -t :.1
explain plan for select /*+ leading(DEPT) USE_HASH(EMP) */ * from DEPT join EMP using(deptno);
select * from dbms_xplan.display(format=>'typical -predicate');
explain plan for select /*+ leading(DEPT) USE_HASH(EMP) cardinality(DEPT 1000) */ * from DEPT join EMP using(deptno);




















































select dbms_sqltune.report_sql_monitor(sql_id,report_level=>'typical',type=>'text') from v$session where username='SCOTT' and status='ACTIVE';
--- tmux select-pane -t :.0
select /*+ leading(DEPT) USE_NL(EMP) monitor */ * from DEPT join EMP using(deptno)
where slow(DEPT.LOC,1)>0 and slow(EMP.COMM,1)>0
/
--- tmux select-pane -t :.1
repeat 100 1


select plan_table_output from v$sql , dbms_sqltune.report_sql_monitor(sql_id=>sql_id,child_number=>child_number) where parsing_schema_name='SCOTT' and users_executing>=1;

select sql_id from v$session, dbms_sqltune.report_sql_monitor(sql_id) where username='SCOTT' and status='ACTIVE';



save bg.sql replace


/

















break on job noduplicates 
select job,empno,ename,hiredate,deptno,dname from emp join dept using(deptno) order by job
/

set long 1000000 longc 1000 linesize 200
column xml format a100

select 
xmlserialize(document
 xmlelement("Departments",
  xmlelement("Department",
   xmlattributes(DEPTNO as "depto",dname),
   xmlagg(
    xmlelement("Employee",xmlattributes(EMPNO as "empno",ENAME,HIREDATE))
   )
  )
 )
as clob indent size=2) as xml
from emp join dept using(deptno)
group by deptno,dname
/

select 
xmlserialize(document
 xmlelement("Jobs",
  xmlelement("Job",
   xmlattributes(JOB as "job"),
   xmlagg(
    xmlelement("Employee",xmlattributes(EMPNO as "empno",ENAME,HIREDATE))
   )
  )
 )
as clob indent size=2) as xml
from emp join dept using(deptno)
group by job
/

select
   json_object('deptno' value deptno,
    'dname' value dname,
    'Employee' value json_arrayagg(
     json_object(
      'empno' value empno,
      ename value ename,
      to_char(hiredate,'yyyy-mm-dd') value hiredate
     ) order by empno
    )
   )
from emp join dept using(deptno)
group by deptno,dname
/





select /*+ leading(dept) use_merge_cartesian(emp) */ * from dept join emp using(deptno)
alter session set statistics_level=all;
select /*+ leading(dept) use_merge_cartesian(emp) */ * from dept join emp using(deptno)
/
select * from dbms_xplan.display_cursor(format=>'allstats last +outline')
/



info v$sql_hint;
select * from v$sql_hint where class='JOIN' order by version;


host TWO_TASK=//localhost/PDB1 sqlplus sys/oracle @ ?/rsbms/admin/utlsampl

#######################################################3##############################3
############################## begin sqlcl env #######################################3
tmux send-keys "echo set sqlformat ansiconsole > /tmp/login.sql " C-M
tmux send-keys "alias sql='SQLPATH=/tmp JAVA_HOME="'$ORACLE_HOME/jdk bash $ORACLE_HOME'"/sqldeveloper/sqlcl/bin/sql'" C-M
tmux send-keys '[ -r /media/sf_Soft/sqlcl/bin/sql ] &&' "alias sql='SQLPATH=/tmp JAVA_HOME="'$ORACLE_HOME/jdk bash '"/media/sf_Soft/sqlcl/bin/sql'" C-M
tmux send-keys "rm -f login.sql" C-M

#tmux send-keys "cat > /tmp/login.sql <<'EOF'" C-M
#tmux send-keys "set sqlformat ansiconsole" C-M
#tmux send-keys 'alias pdb1=alter session set container=pdb1; ' C-M
#tmux send-keys 'alias pdb2=alter session set container=pdb2; ' C-M
#tmux send-keys 'alias cdb=alter session set container=cdb$root; ' C-M
#tmux send-keys "set hist limit 20 time on echo on " C-M
#tmux send-keys "EOF" C-M
#tmux send-keys "host echo set serveroutput off >> login.sql " C-M


tmux send-keys ". oraenv <<< CDB1" C-M
tmux send-keys -t :.0 "sql sys/oracle@//localhost/PDB1${DOMAIN} as sysdba" C-M
tmux send-keys "alter system flush shared_pool; " C-M
tmux send-keys "alter system set shared_pool_size=600M scope=memory; " C-M
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
#tmux send-keys "variable t varchar2(10)" C-M
#tmux send-keys "exec :t:= DBMS_STATS.CREATE_ADVISOR_TASK('my_task1'); " C-M
#tmux send-keys "variable e varchar2(10)" C-M
#tmux send-keys "exec :e:= DBMS_STATS.EXECUTE_ADVISOR_TASK('my_task1'); " C-M
#tmux send-keys "variable r clob" C-M
#tmux send-keys "exec :r:= DBMS_STATS.REPORT_ADVISOR_TASK('my_task1'); " C-M
tmux send-keys "set linesize 100 trimspool on long 1000000 longc 10000" C-M
tmux send-keys "column R format a100" C-M

tmux send-keys "print" C-M
tmux send-keys "alter session set statistics_level=all; " C-M
tmux send-keys "alter session set nls_date_format='dd-mon-yy hh24:mi:ss'; " C-M
tmux send-keys "set serveroutput off define off; " C-M
tmux send-keys "set sqlformat ansiconsole" C-M
tmux send-keys "select pname,pval1,calculated,formula from sys.aux_stats"'$'" where sname='SYSSTATS_MAIN'" C-M "model" C-M "  reference sga on (" C-M "    select name,value from v"'$'"sga " C-M "        ) dimension by (name) measures(value)" C-M "  reference parameter on (" C-M "    select name,decode(type,3,to_number(value)) value from v"'$'"parameter where name='db_file_multiblock_read_count' and ismodified!='FALSE'" C-M "    union all" C-M "    select name,decode(type,3,to_number(value)) value from v"'$'"parameter where name='sessions'" C-M "    union all" C-M "    select name,decode(type,3,to_number(value)) value from v"'$'"parameter where name='db_block_size'" C-M "        ) dimension by (name) measures(value)" C-M "partition by (sname) dimension by (pname) measures (pval1,pval2,cast(null as number) as calculated,cast(null as varchar2(60)) as formula) rules(" C-M "  calculated['MBRC']=coalesce(pval1['MBRC'],parameter.value['db_file_multiblock_read_count'],parameter.value['_db_file_optimizer_read_count'],8)," C-M "  calculated['MREADTIM']=coalesce(pval1['MREADTIM'],pval1['IOSEEKTIM'] + (parameter.value['db_block_size'] * calculated['MBRC'] ) / pval1['IOTFRSPEED'])," C-M "  calculated['SREADTIM']=coalesce(pval1['SREADTIM'],pval1['IOSEEKTIM'] + parameter.value['db_block_size'] / pval1['IOTFRSPEED'])," C-M "  calculated['   multi block Cost per block']=round(1/calculated['MBRC']*calculated['MREADTIM']/calculated['SREADTIM'],4)," C-M "  calculated['   single block Cost per block']=1," C-M "  formula['MBRC']=case when pval1['MBRC'] is not null then 'MBRC' when parameter.value['db_file_multiblock_read_count'] is not null then 'db_file_multiblock_read_count' when parameter.value['_db_file_optimizer_read_count'] is not null then '_db_file_optimizer_read_count' else '= _db_file_optimizer_read_count' end," C-M "  formula['MREADTIM']=case when pval1['MREADTIM'] is null then '= IOSEEKTIM + db_block_size * MBRC / IOTFRSPEED' end," C-M "  formula['SREADTIM']=case when pval1['SREADTIM'] is null then '= IOSEEKTIM + db_block_size        / IOTFRSPEED' end," C-M "  formula['   multi block Cost per block']='= 1/MBRC * MREADTIM/SREADTIM'," C-M "  formula['   single block Cost per block']='by definition'," C-M "  calculated['   maximum mbrc']=round(sga.value['Database Buffers']/(parameter.value['db_block_size']*parameter.value['sessions']))," C-M "  formula['   maximum mbrc']='= buffer cache size in blocks / sessions'" C-M ")" C-M "/" C-M "save /tmp/aux_stats.sql replace" C-M

sleep 2 ; tmux send-keys C-M
sleep 2 ; tmux send-keys C-M
sleep 2 ; tmux send-keys C-M
sleep 2 ; tmux send-keys C-M
sleep 2 ; tmux send-keys C-M


###################################################################
# F10
###################################################################

tmux send-keys "set sqlformat ansiconsole" C-M

###################################################################
# stale statistics
###################################################################
sleep 5
tmux send-keys C-M

tmux send-keys "create table DEMO.DEMO(day date); " C-M
tmux send-keys "insert into DEMO.DEMO select trunc(date'2016-01-01'+(rownum-1)/100) from xmltable('1 to 36600'); " C-M
# --> hundred of rows every for one year
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','DEMO')" C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO; " C-M

# I query the last date
tmux send-keys "alter session set statistics_level=all; " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2016-12-31'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
#--> good estimation

# I insert a new day
tmux send-keys "insert into DEMO.DEMO select date '2017-01-01' from xmltable('1 to 100'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2017-01-01'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
#--> still good estimation (didn't gather stats)

tmux send-keys "insert into DEMO.DEMO select date '2017-01-02' from xmltable('1 to 100'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2017-01-02'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
#--> with one more day, estimation decreases

tmux send-keys "insert into DEMO.DEMO select trunc(date'2017-01-03'+(rownum-1)/100) from xmltable('1 to 3100'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2017-02-02'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
#--> after one month it becomes worse

tmux send-keys "insert into DEMO.DEMO select trunc(date'2017-02-03'+(rownum-1)/100) from xmltable('1 to 33300'); " C-M
tmux send-keys "select count(*),min(day),max(day) from DEMO.DEMO where day = date '2018-01-01'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
#--> after one year misestimate can lead to very bad execution plans


###################################################################
# Statistics History
###################################################################
sleep 5
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST',method_opt=>'for all columns size skewonly'); " C-M
tmux send-keys "host clear" C-M


# I get the date.
tmux send-keys "select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual; " C-M

# I gather statistics
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST'); " C-M
# I have a table and query that is ok
tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
#--> bad estimation. I want to revert back to before stats gathering

tmux send-keys "set autotrace off long 10000 longc 10000 " C-M
tmux send-keys "select report from table(" C-M
tmux send-keys " dbms_stats.diff_table_stats_in_history(" C-M
tmux send-keys "'DEMO','HIST', timestamp'" 
tmux copy-mode ; tmux send-key -X search-backward "TO_CHAR(SYSDATE,'YY" ; tmux send-key -X cursor-down ; tmux send-key -X begin-selection ; tmux send-keys -X end-of-line ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel
tmux paste-buffer 
tmux send-keys "',current_timestamp,pctthreshold=>10" C-M
tmux send-keys " )" C-M
tmux send-keys "); " C-M ; sleep 1
#--> I see the difference: histograms

tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M

tmux send-keys "exec dbms_stats.restore_table_stats('DEMO','HIST',as_of_timestamp=>timestamp'" 

tmux copy-mode ; tmux send-key -X search-backward "TO_CHAR(SYSDATE,'YY" ; tmux send-key -X cursor-down ; tmux send-key -X begin-selection ; tmux send-keys -X end-of-line ; tmux send-keys -X cursor-left ; tmux send-keys -X stop-selection ; sleep 1 ; tmux send-key -X copy-selection-and-cancel

tmux paste-buffer 
tmux send-keys "',no_invalidate=>false); " C-M

tmux send-keys "select * from DEMO.HIST where flag='Y'; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M

tmux send-keys "select dbms_stats.get_stats_history_retention from dual; " C-M

###################################################################
# Pending Statistics
###################################################################
sleep 5
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

###################################################################
# Histograms and bind variables
###################################################################
sleep 5
tmux send-keys "exec dbms_stats.gather_table_stats('DEMO','HIST',method_opt=>'for all columns size skewonly'); " C-M
tmux send-keys "host clear" C-M

tmux send-keys "variable flag char(1) " C-M
tmux send-keys "exec :flag:='Y' " C-M
tmux send-keys "select count(id) from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys "exec :flag:='N' " C-M
tmux send-keys "select count(id) from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
# run it again 
tmux send-keys "select count(id) from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
#--> Adaptive Cursor Sharing

#tmux send-keys 'alter session set "_optimizer_use_histograms"=false; ' C-M
#tmux send-keys "select count(id) n from DEMO.HIST where flag=:flag; " C-M
#tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys 'alter session set "_optim_peek_user_binds"=false; ' C-M
tmux send-keys "select count(id) n from DEMO.HIST where flag=:flag; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M


###################################################################
# Session Statistics (GTT)
###################################################################
sleep 5

tmux send-keys "connect demo/demo@//localhost/pdb1 " C-M
 send-keys "host clear" C-M

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

	tmux split-window -l 20 "ssh oracle@${HOST:-192.168.78.114}"
	tmux send-keys "sqlplus demo/demo@//localhost/PDB; " C-M

	tmux send-keys "insert into DEMO_GTT select rownum from dual connect by level<=1000; " C-M
	tmux send-keys "exec dbms_stats.gather_table_stats(user,'DEMO_GTT',no_invalidate=>true); " C-M
	tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
	tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>' iostats last')); " C-M






###################################################################
# set statistics
###################################################################
sleep 5

tmux send-keys "connect demo/demo@//localhost/pdb1 " C-M
tmux send-keys "exec dbms_stats.set_table_prefs(user,'DEMO_GTT','GLOBAL_TEMP_TABLE_STATS','SHARED'); " C-M
tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M
tmux send-keys "exec dbms_stats.set_table_stats(user,'DEMO_GTT',numrows=>1e6,no_invalidate=>false); " C-M
tmux send-keys "select /*+ gather_plan_statistics */ count(*) from DEMO_GTT; " C-M
tmux send-keys "select * from table(dbms_xplan.display_cursor(format=>'iostats last')); " C-M


###################################################################
# fixed statistics
###################################################################

###################################################################
# system statistics
###################################################################
sleep 5


#tmux send-keys "set serverout on define off; " C-M
#tmux send-keys "exec dbms_stats.set_global_prefs('TRACE',0); " C-M
#tmux send-keys "exec dbms_stats.set_global_prefs('TRACE',1018575); " C-M
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



###################################################################
# Optimizer Statsistics Advisor
###################################################################

tmux send-keys "exec DBMS_STATS.DROP_ADVISOR_TASK('my_task2'); " C-M
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


###################################################################
# END (Bonus) 12:30 - 13:20
###################################################################

###################################################################
# Automatic statistics collection
###################################################################

tmux send-keys "select window_name,window_next_time,autotask_status,optimizer_stats from DBA_AUTOTASK_WINDOW_CLIENTS; " C-M
tmux send-keys "select window_name,window_start_time,window_end_time from DBA_AUTOTASK_WINDOW_HISTORY order by 1 desc fetch first 5 rows only; " C-M
#--> maintenance window is created and enabled
tmux send-keys "select client_name,status from DBA_AUTOTASK_CLIENT where client_name='auto optimizer stats collection'; " C-M
tmux send-keys "select task_name,status,last_good_date,last_try_date from DBA_AUTOTASK_TASK where client_name='auto optimizer stats collection'; " C-M
#--> statistic collection maintenance task is enabled
show parameter job

tmux send-keys "--" C-M

###################################################################
# XXXXXXXXXXXXXXXXX
###################################################################


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








CDB1.__data_transfer_cache_size=0
CDB1.__db_cache_size=360710144
CDB1.__inmemory_ext_roarea=0
CDB1.__inmemory_ext_rwarea=0
CDB1.__java_pool_size=4194304
CDB1.__large_pool_size=20971520
CDB1.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment
CDB1.__pga_aggregate_target=218103808
CDB1.__sga_target=859832320
CDB1.__shared_io_pool_size=37748736
CDB1.__shared_pool_size=419430400
CDB1.__streams_pool_size=0
*.audit_file_dest='/u01/app/oracle/admin/CDB1A/adump'
*.audit_trail='db'
*.compatible='12.2.0'
*.control_files='/u01/oradata/CDB1A/control01.ctl','/u01/fast_recovery_area/CDB1A/control02.ctl'
*.db_block_size=8192
*.db_name='CDB1'
*.db_recovery_file_dest='/u01/fast_recovery_area'
*.db_recovery_file_dest_size=1024m
*.db_unique_name='CDB1A'
*.dg_broker_start=false
*.diagnostic_dest='/u01/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=CDB1XDB)'
*.enable_pluggable_database=true
*.log_archive_format='%t_%s_%r.dbf'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.open_cursors=300
*.pga_aggregate_target=205m
*.processes=320
*.remote_login_passwordfile='EXCLUSIVE'
*.service_names='CDB1'
*.sga_target=819m
*.shared_pool_size=419430400
*.undo_tablespace='UNDOTBS1'

