tmux kill-window -t "dbvrep"
tmux new-window -k -n "dbvrep" 
id | grep oracle || ssh oracle@192.168.56.188
arc
echo 'shutdown immediate' | ORACLE_SID=CDB2 sqlplus / as sysdba
echo 'startup force' | ORACLE_SID=CDB1 sqlplus / as sysdba
. oraenv
CDB1
cat > /u01/app/oracle/product/18.0.0/dbhome_1/network/admin/sqlnet.ora <<TAC
SQLNET.ALLOWED_LOGON_VERSION_SERVER=8
TAC
sqlplus / as sysdba
create pluggable database PDB1 admin user admin identified by oracle;
create pluggable database PDB2 admin user admin identified by oracle;
alter pluggable database all open;
alter pluggable database all save state;
alter session set container=PDB2;
drop user DEMO cascade;
grant DBA to DEMO identified by demo container=current;
create tablespace USERS;
alter user DEMO default tablespace USERS;
alter session set container=PDB1;
drop user DEMO cascade;
grant DBA to DEMO identified by demo container=current;
create tablespace USERS;
alter user DEMO default tablespace USERS;
create table DEMO.DEMO ( id number primary key, x varchar2(30) );
quit

cat > /u01/app/oracle/product/18.0.0/dbhome_1/network/admin/tnsnames.ora <<TAC
PDB1=(DESCRIPTION=(CONNECT_DATA=(SERVICE_NAME=PDB1))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521)))
PDB2=(DESCRIPTION=(CONNECT_DATA=(SERVICE_NAME=PDB2))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521)))
TAC
tnsping PDB1
tnsping PDB2

echo "alter user system identified by oracle;" | sqlplus / as sysdba

--- # F12

rm -rf /home/oracle/ORA2ORA
dbvrep
setup wizard
Yes
Yes
ORA2ORA
trial
MAX
/home/oracle/ORA2ORA
/u01/app/oracle/product/18.0.0/dbhome_1/network/admin
Yes
--- # source PDB1
Oracle
PDB1
SYS
oracle
SYSTEM
oracle
dbvrep
dbvpasswd
Yes
USERS
TEMP
add
--- # target PDB2
Oracle
PDB2
SYS
oracle
SYSTEM
oracle
dbvrep
dbvpasswd
Yes
USERS
TEMP
done
--- # replication pairs
1
2
Yes
No
Yes
No
No
60
ddl-only
ddl_run
done
--- # replicate tables
1
DEMO
No
---
Yes
---
---
No
Yes
Yes
Yes
Yes
Yes
OLD$
NEW$
Yes
Yes
Yes
Yes
done
--- # process configuration
1
---
Linux
No
No
---
No
2
---
Linux
No
No
---
No
done
No
quit
--- # run the scripts
echo "alter database add supplemental log data;" | sqlplus / as sysdba
/home/oracle/ORA2ORA/ORA2ORA-all.sh
--- # Nextsteps.txt
/home/oracle/ORA2ORA/ORA2ORA-run-vm188.sh
--- # start the console
/home/oracle/ORA2ORA/start-console.sh
--- tmux split-window
--- tmux select-pane -t :.1
id | grep oracle || ssh oracle@192.168.56.188
--- # do some changes in the source
echo "alter system switch logfile;" | sqlplus / as sysdba
sqlcl demo/demo@PDB1
show con_name
create table DEMO ( id number primary key, x varchar2(30) );
insert into DEMO select rownum, 'x' from xmltable('1 to 5');
commit;
select * from DEMO;
connect demo/demo@PDB2
select * from DEMO;
alter session set nls_date_format='dd-mon hh24:mi:ss';
select OPERATION,DATE_CHANGE,DATE_COMMIT,OS_PROG,OLD$ID,NEW$ID,OLD$X,NEW$X from DEMO;
repeat 1000 1
--- tmux split-window
--- tmux select-pane -t :.2
id | grep oracle || ssh oracle@192.168.56.188
sqlcl demo/demo@PDB1
delete from DEMO;
commit;
insert into DEMO values(1,'x');
insert into DEMO values(2,'x');
commit;
update DEMO set x=upper(x);
update DEMO set x=upper(x);
update DEMO set x='x';
commit;








--- # now trying kafka
--- tmux select-pane -t :.0
shutdown all
Yes
quit
rm -rf /home/oracle/ORA2KAFKA
type dbvrep
sudo ln /usr/bin/dbvrep /usr/bin/dbvpf
dbvpf
setup wizard
Yes
ORA2KAFKA
---
/home/oracle/ORA2KAFKA
/u01/app/oracle/product/18.0.0/dbhome_1/network/admin
Yes
--- # source PDB1
Oracle
PDB1
SYS
oracle
SYSTEM
oracle
dbvpf
dbvpasswd
Yes
USERS
TEMP
done
--- # replication pairs
1
2
Yes
No
Yes
No
60
single-scn
load
done
--- # replicate tables
1
DEMO
No
---
No
---
done
--- # process configuration
1
---
Linux
No
No
---
No
done
No
quit
/home/oracle/ORA2KAFKA/ORA2KAFKA-all.sh
/home/oracle/ORA2KAFKA/ORA2KAFKA-run-vm188.sh
echo "alter system switch logfile;" | sqlplus / as sysdba
/home/oracle/ORA2KAFKA/start-console.sh
--- tmux select-pane -t :.2
insert into DEMO select rownum, 'x' from xmltable('1 to 1000');
commit;



