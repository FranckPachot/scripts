--- tmux set-option display-time 5000
--- ########## open windows and connect
--- 
--- tmux kill-window -t "MT-Workshop"
--- tmux new-window -k -n "MT-Workshop" 
pstree -a
--- tmux display-message "testing ping to server..." 
--- [ "$HOST" == no ] || ping -w 5000 -n 1 ${HOST:-192.168.56.122} || exit
--- tmux display-message "${HOST:-192.168.56.122} server ok."
--- [ "$HOST" == no ] || tmux send-keys -t :.0 "ssh oracle@${HOST:-192.168.56.122}" C-M
lsnrctl status | grep --color=auto READY
--- tmux split-window -l 20
--- [ "$HOST" == no ] || tmux send-keys -t :.1 "ssh oracle@${HOST:-192.168.56.122}" C-M
--- tmux select-pane -t :.0
--- tmux display-message "wait for tmux window..."
--- ########## defaults for sqlcl
mkdir -p ~/sql ; echo -e "set sqlformat ansiconsole\nset time on" > ~/sql/login.sql
alias sqlcl='JAVA_HOME=$ORACLE_HOME/jdk SQLPATH=~/sql bash $ORACLE_HOME/sqldeveloper/sqlcl/bin/sql -L'
alias connect=sqlcl ; alias sql=sqlcl
alias host=""
alias nls_date=alter session set nls_date_format='dd-MON-YYYY HH:MI:ss';
alias quit='echo -e "\n\n\n\n"'
--- tmux select-pane -t :.1
alias sqlcl='JAVA_HOME=$ORACLE_HOME/jdk SQLPATH=/tmp/SQLPATH bash $ORACLE_HOME/sqldeveloper/sqlcl/bin/sql -L'
alias connect=sqlcl ; alias sql=sqlcl
alias quit='echo -e "\n\n\n\n"'
--- tmux select-pane -t :.0
--- tmux resize-pane -Z -t :.0
alias arc='df -h /u01 ; rm -rf /u01/app/oracle/audit/CDB?/* ; date > /u01/app/oracle/diag/rdbms/cdb1/CDB1/trace/alert_CDB1.log ; for i in $(awk -F: "/^[a-zA-Z0-9]+:/{print \$1}" /etc/oratab | sort -u) ; do . oraenv <<< $i ; rman target / <<< "set echo on;delete noprompt obsolete;delete noprompt archivelog all;" ;  done | egrep "[(:].*[)]$" ; wait ; df -h /u01'

--- ### here to set env only  ##########################################################

--- ########## some config
grep -E 'CDB1:.*:PDB1' /etc/oratab || echo -e '\n\n\n#following is added for DMK:\nCDB1:.::PDB1' >> /etc/oratab
adrci exec="set home diag/rdbms/cdb1/CDB1; purge -age 1"
lsnrctl stop "(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1522)))"
sed -i '/LISTENER_PDB1/d' /u01/app/oracle/network/admin/listener.ora
--- ########## check hugepages
grep -E "^Huge[pP]age|^" /proc/meminfo
for i in $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log ; do echo $i: ; grep -A4 PAGESIZE $i | grep -v ^20 | tail -4 ; done | grep -E "^|[0-9][0-9][0-9]+[K]*"
--- ########## check network encryption
sqlcl /@CDB1 as sysdba 
set sqlformat ansiconsole
alias f=format buffer;
alias desc f format buffer;
alias nls_date=alter session set nls_date_format='dd-MON-YYYY HH:MI:ss';
alias desc nls_date set nls_date_format='dd-MON-YYYY HH:MI:ss';
alias x=select * from dbms_xplan.display_cursor(format=>'basic');
alias desc x display_cursor(format=>'basic');
alias X=select * from dbms_xplan.display_cursor(format=>'basic memstats last');
alias desc X display_cursor(format=>'typical memstats last');
alias S=alter session set statistics_level=all;
alias desc S statistics_level=all;
alias rau=select v.*,"%"*"limit MB" "MB" from (select (select name from v$database) database,file_type,percent_space_used-percent_space_reclaimable "%", space_limit/1024/1024/100 "limit MB",percent_space_used,percent_space_reclaimable from v$recovery_area_usage , v$recovery_file_dest) v;
alias desc rau v$recovery_area_usage;
select sid,network_service_banner,client_driver 
from v$session_connect_info where sid=sys_context('userenv','sid')
order by decode(sid,sys_context('userenv','sid'),null,sid) nulls last;
quit
--- ########## show recovery area usage
for ORACLE_SID in CDB2 CDB1 ; do ps -edf | grep "ora_pmon[_]${ORACLE_SID}$" ; if [ $? -eq 0 ] ; then sqlplus -s / as sysdba <<< 'select (select name from v$database) database,file_type,percent_space_used-percent_space_reclaimable from v$recovery_area_usage;' | grep -vE "( 0|selected[.])$" | grep -E "([0-9.]*[1-9]$|^)" ; fi ; done
grep "^[A-Za-z0-9]*:" /etc/oratab
---
$ORACLE_HOME/OPatch/opatch lspatches
--- ####################################################################
--- ### F12 until there ################################################
--- ####################################################################
---
--- ####################################################################
--- ### The workshop environment
--- ####################################################################
grep "^[A-Za-z0-9]*:" /etc/oratab
--- # We have Huge Pages defined (because it is always recommended)
grep -E "^Huge[pP]age|^" /proc/meminfo | tail
for i in $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log ; do echo $i: ; grep -A4 PAGESIZE $i | grep -v ^20 | tail -4 ; done | grep -E "^|[0-9][0-9][0-9]+[K]*"
--- # We have DMK to connect to the container databases
dbi
u
--- # We have one listener on port 1521
lsnrctl status LISTENER | grep --color=auto -E '0.0.0.0|1521|^|"CDB1"'
--- # we have one container database CDB1
CDB1
env | grep -E "^(ORACLE_SID|^TWO_TASK|ORACLE_HOME)="
--- # We can use SQLcl instead of sqlplus (because it's cool)
alias | grep "^alias sqlcl="
sqlcl / as sysdba
help
select object_name from dba_objects where object_name like '%%ADE_LABEL_RDBMS%';
set serveroutput on sqlformat ansiconsole
exec dbms_qopatch.get_sqlpatch_status;
--- # We have one listener on default port
show parameter listener
---
--- # We use network encryption (because it is always recommended)
select sid,network_service_banner,client_driver from v$session_connect_info where sid=sys_context('userenv','sid') order by decode(sid,sys_context('userenv','sid'),null,sid) nulls last;
quit
--- # We will use EZCONNECT connection strings (because we are lazy)
tnsping //$(hostname):1521/CDB1
---
--- # We are using external password file here (because it is recommended)
grep --color=auto WALLET ${TNS_ADMIN:-$ORACLE_HOME/network/admin}/sqlnet.ora
grep --color=auto ^CDB ${TNS_ADMIN:-$ORACLE_HOME/network/admin}/tnsnames.ora
mkstore -wrl /u01/app/oracle/product/12.2.0/dbhome_1/network/admin/wallet -listCredential
3x73rn4l_p455w0rd_f1l3
--- # Check recovery area size (it may fill-up during the workshop)
for ORACLE_SID in CDB2 CDB1 ; do ps -edf | grep "ora_pmon[_]${ORACLE_SID}$" ; if [ $? -eq 0 ] ; then sqlplus -s / as sysdba <<< 'select (select name from v$database) database,file_type,percent_space_used-percent_space_reclaimable from v$recovery_area_usage;' | grep -vE "( 0|selected[.])$" | grep -E "([0-9.]*[1-9]$|^)" ; fi ; done
--- # Here is a small alias to cleanup the recovery area and adump if needed
alias arc='df -h /u01 ; rm -rf /u01/app/oracle/audit/CDB?/* ; date > /u01/app/oracle/diag/rdbms/cdb1/CDB1/trace/alert_CDB1.log ; for i in $(awk -F: "/^[a-zA-Z0-9]+:/{print \$1}" /etc/oratab | sort -u) ; do . oraenv <<< $i ; rman target / <<< "set echo on;delete noprompt obsolete;delete noprompt archivelog all;" ;  done | egrep "[(:].*[)]$" ; wait ; df -h /u01'
arc
--- ####################################################################
--- ### What is in CDB1
--- ####################################################################
--- ## Instance and Database
sqlcl /@CDB1 as sysdba
set sqlformat ansiconsole
--- # In a CDB the instance must have enable_pluggable_database=true
show parameter enable_pluggable_database
---
--- # In CDB the database must be created by ENABLE PLUGGABLE DATABASE
select dbid,name,open_mode,database_role,db_unique_name,cdb,con_id from v$database;
--- ## From the instance, list the containers: show pdbs, V$PDBS, X$CON
show pdbs
select * from dbms_xplan.display_cursor()
/
select * from x$con
/
select * from v$pdbs
/
desc v$pdbs
--- # multiple identifiers: NAME, CON_ID, CON_UID, GUID, DBID
select name,con_id,dbid,con_uid,guid,proxy_pdb,pdb_count from v$pdbs
/
--- # V$PDBS filters out CDB$ROOT (CON_ID=0) which is not a PDB
select * from dbms_xplan.display_cursor()
/
--- ## From the database, list the containers:  DBA_PDBS, CONTAINER$
select * from dba_pdbs
/
select * from dbms_xplan.display_cursor(format=>'basic +predicate -plan_hash')
/
--- # The name of the containers are in DBA_OBJECTS
select owner,object_name,object_type,oracle_maintained,sharing,object_id 
from dba_objects where object_type='CONTAINER' order by created
/
alter session set nls_date_format='dd-MON-yy hh24:mi';
select obj#,con_id#,dbid,con_uid,status,status,undots,postplugtime from container$
/
--- # STATUS is: 0:UNUSABLE 1:NEW 2:NORMAL 3:UNPLUGGED 5:RELOCATING 6:REFRESHING 7:RELOCATED
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs
/
--- ## EM Express is configured
select 'https://'||utl_inaddr.get_host_address(host_name)||':'||dbms_xdb_config.gethttpsport()||'/em' "EM Express URL" from v$instance where dbms_xdb_config.gethttpsport()>0 union all select 'http://'||utl_inaddr.get_host_address(host_name)||':'||dbms_xdb_config.gethttpport()||'/em' from v$instance where dbms_xdb_config.gethttpport()>0;
--- # Click on 'CDB (1 PDBs)' to go to the Containers page
--- ####################################################################
--- ### Switch to containers, common users and connections
--- ####################################################################
--- ## SHOW CON_ID, CON_NAME, alter session set container
--- # A bequeath connect goes to CDB$ROOT and sees all containers
connect / as sysdba
show user
---
show connection
---
show con_id
---
show con_name
---
--- # A common user can switch to PDB and see only local PDBs
show pdbs
---
alter session set container = PDB1;
---
show con_id
---
show con_name
---
show pdbs
---
show user
--- ## Common users and schemas
--- # Common users are visible in all containers
select username,authentication_type,oracle_maintained,to_char(last_login,'dd-mon-yy hh24:mi:ss') last_login,common from dba_users order by 1;
--- # There are only common user in CDB$ROOT
alter session set container = CDB$ROOT;
select username,authentication_type,oracle_maintained,to_char(last_login,'dd-mon-yy hh24:mi:ss') last_login,common from dba_users order by 1;
create user TRYING_TO_CREATE_LOCAL_USER_IN_ROOT identified by oracle container=current
/
--- # Common users can have a schema in each container
create table SYSTEM.MYTABLE as select 'created in root' text from dual
/
select * from SYSTEM.MYTABLE;
alter session set container=PDB1;
select * from SYSTEM.MYTABLE;
create table SYSTEM.MYTABLE as select 'created in pdb' text from dual
/
select * from SYSTEM.MYTABLE;
--- ## Containers and transactions
--- # A session cannot have a transaction spanning multiple containers
delete from SYSTEM.MYTABLE;
select start_time,used_urec,con_id from v$transaction;
alter session set container = CDB$ROOT;
select start_time,used_urec,con_id from v$transaction;
delete from SYSTEM.MYTABLE;
alter session set container=PDB1;
commit;
alter session set container = CDB$ROOT;
delete from SYSTEM.MYTABLE;
commit;
alter session set container = CDB$ROOT;
--- ## Common users can read across all containers
select * from SYSTEM.MYTABLE;
select * from containers(SYSTEM.MYTABLE);
select * from dbms_xplan.display_cursor(format=>'basic +predicate -plan_hash')
/
select * from containers(SYSTEM.MYTABLE) where con_id=4;
--- ####################################################################
--- ### Services
--- ####################################################################
host lsnrctl status LISTENER | grep --color=auto -E '0.0.0.0|1521|^|Service ".*"'
--- ## In addition to the CDB declaring the db_unique_name, each PDB declares a default service
show pdbs
--- # A service directly connects to a container
select name,network_name,creation_date,pdb,con_id from v$services order by con_id;
--- # The services are registered to the local listener
show parameter listener;
desc v$parameter;
--- # A PDB can register to a specific listener
select name,ispdb_modifiable,description from v$parameter where name like '%listener%';
--- # We will create a listener for PDB1 on port 152
alter session set container=PDB1;
host echo "LISTENER_PDB1=(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1522)))" >> $TNS_ADMIN/listener.ora
host lsnrctl start LISTENER_PDB1
show parameter local_listener
alter system set local_listener='(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1522)))' scope=memory;
show parameter local_listener
host lsnrctl status LISTENER_PDB1
select con_id,con_uid,guid,name,open_mode from v$pdbs;
--- # Note that the local listener of the PDB still knows all PDBs
host lsnrctl status LISTENER
--- # Now we can connect to PDB1 through port 1522
connect sys/oracle@//localhost:1522/PDB1 as sysdba
show con_name
--- ## User created services are associated to a PDB
--- # Those are default services (like db_unique_name for the CDB) but it is recommended to create you application service
--- #  - with Oracle Restart or Oracle Clusterware, srvctl add/modify has a -pdb option
--- #  - without Grid Infrastructure, use DBMS_SERVICE
exec dbms_service.create_service(service_name=>'APP_PDB1',network_name=>'APP_PDB1');
--- # The service_names parameter concerns only the CDB
show parameter service
select name,value,ispdb_modifiable,description from v$parameter where name like '%service%';
--- # Service APP_DB1 is created
select name,network_name,creation_date,pdb from dba_services;
select name,network_name,creation_date,con_id from v$active_services;
--- # Starting the service
exec dbms_service.start_service(service_name=>'APP_PDB1');
select name,network_name,creation_date,con_id from v$active_services;
--- ## What about applications connecting with the SID?
--- # The application should connect to the service
connect sys/oracle@//localhost:1522/APP_PDB1 as sysdba
select dbms_tns.resolve_tnsname('//localhost:1522/APP_PDB1') from dual;
show con_name
select sys_context('userenv','cdb_name'), sys_context('userenv','con_name'), sys_context('userenv','service_name') from dual;
--- # With the SID we can connect to the CDB
connect sys/oracle@localhost:1521:CDB1 as sysdba
show con_name
select sys_context('userenv','cdb_name'), sys_context('userenv','con_name'), sys_context('userenv','service_name') from dual;
--- # localhost:1521:CDB1 is equivalent to:
connect sys/oracle@(DESCRIPTION=(CONNECT_DATA=(SID=CDB1))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521))) as sysdba
select sys_context('userenv','cdb_name'), sys_context('userenv','con_name'), sys_context('userenv','service_name') from dual;
--- # With the SID we can connect to the CDB but we cannot connect to the PDB directly
connect sys/oracle@"(DESCRIPTION=(CONNECT_DATA=(SID=APP_PDB1))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1522)))" as sysdba
--- # Better change the connection string, but Oracle provides a workaround
host echo "USE_SID_AS_SERVICE_LISTENER_PDB1=on" >> $TNS_ADMIN/listener.ora
host lsnrctl reload LISTENER_PDB1
host lsnrctl status LISTENER_PDB1
connect sys/oracle@"(DESCRIPTION=(CONNECT_DATA=(SID=APP_PDB1))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1522)))" as sysdba
select sys_context('userenv','cdb_name'), sys_context('userenv','con_name'), sys_context('userenv','service_name') from dual;
--- ## The GUID service
column GUID new_value GUID
select GUID from v$PDBs;
host lsnrctl status LISTENER_PDB1
--- # just for the fun, but do not use it as it is used internally only:
connect sys/oracle@(DESCRIPTION=(CONNECT_DATA=(SERVICE_NAME=&GUID))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1522))) as sysdba
select sys_context('userenv','cdb_name'), sys_context('userenv','con_name'), sys_context('userenv','service_name') from dual;
--- ####################################################################
--- ### Create and Drop PDBs
--- ####################################################################
connect / as sysdba
connect / as sysdba
show pdbs
--- ## Create a PDB from PDB$SEED
--- # Within a CDB, connected to CDB$ROOT
create pluggable database PDB2
/
--- # We need to define a local user at creation (don't ask why) and role (default is PDB_DBA with set container, create PDB, create session)
create pluggable database PDB2 admin user admin identified by oracle roles=(DBA)
/
--- # With OMF (or ASM) we don't need to specify the file names
show parameter db_create
--- # But without OMF, they are specified with a convert from the source
--- # (all created PDB is actually a clone). Here the source is PDB$SEED
show pdbs
select name from v$datafile where con_id=2;
--- # We can define the conversion as a default for the session (don't ask why) 
show parameter pdb_file_name_convert
--- # Or in the CREATE PDB statement
create pluggable database PDB2 admin user pdbadmin identified by oracle
 file_name_convert=('/pdbseed/','/PDB2/')
/
show pdbs
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
--- # The status is new (was 'UNUSABLE durint the creation)
host adrci exec="set home diag/rdbms/cdb1/CDB1; show alert -tail 50 " | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|^)"
--- # We have to open it once to get it in NORMAL
alter pluggable database PDB2 open
/
show pdbs
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
--- # The absolute file# has been changed in the dictionary and file headers
host adrci exec="set home diag/rdbms/cdb1/CDB1; show alert -tail 50 " | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|^)"
--- ## Open and Close PDBS
--- # From CDB$ROOT
alter pluggable database PDB2 close;
alter pluggable database PDB2 open;
--- # From the PDB
alter session set container=PDB2;
alter pluggable database PDB2 close;
alter pluggable database PDB2 open;
--- # No need to name it here
alter pluggable database close;
alter pluggable database open;
--- # Also, for syntax compatibility
shutdown
startup
--- # Close immediate (kills connected sessions)
alter pluggable database PDB2 close immediate;
--- # A closed PDB is in MOUNTED state (there is no NOMOUNT)
show pdbs
--- # We can open read only a closed PDB
alter pluggable database PDB2 open read only;
--- # we can close + open with force
alter pluggable database PDB2 open read write;
show pdbs
alter pluggable database PDB2 open read write force;
show pdbs
--- # there is also a close abort (for example if SYSTEM is lost)
alter pluggable database PDB2 close abort;
alter pluggable database PDB2 open;
alter pluggable database PDB2 recover;
alter pluggable database PDB2 open;
host adrci exec="set home diag/rdbms/cdb1/CDB1; show alert -tail 50 " | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|^)"
--- # this is possible only in archivelog mode
select ksppinm,ksppstvl,ksppdesc,ksppstdfl from x$ksppi join x$ksppsv using(indx) where ksppinm like '%pdb_close%';
--- ## Drop a PDB
alter pluggable database PDB2 close immediate;
drop pluggable database PDB2;
show con_name
alter session set container=CDB$ROOT;
drop pluggable database PDB2;
--- # You must drop the datafiles with it
select name from v$datafile;
select name from v$tempfile;
host du -a /u01/oradata/CDB1/PDB2
drop pluggable database PDB2 including datafiles;
host du -a /u01/oradata/CDB1/PDB2
--- ## Create a PDB from another PDB
create pluggable database PDB2 from PDB1
/
create pluggable database PDB2 from PDB1
 file_name_convert=('/PDB1/','/PDB2/')
/
--- # in 12.2 the source doesn't need to be opened read only
show pdbs
alter pluggable database PDB2 open;
show pdbs
alter session set container=PDB2;
--- # A clone does not mention the admin user because it inherits the one from the source
select * from dba_sys_privs where grantee='PDB_DBA';
select * from dba_role_privs where granted_role='PDB_DBA';
--- ## Some PDB creation options
alter session set container=CDB$ROOT;
create pluggable database PDB3 
 admin user myadmin identified by myadmin roles=(SYSDBA,DBA)
 file_name_convert=('/pdbseed/','/PDB3/')
 storage ( maxsize 1G max_shared_temp_size 100M )
 path_prefix='/tmp/PDB3'
 default tablespace MYDEFAULT datafile '/u01/oradata/CDB1/PDB3/mydefault.dbf' size 10M
 user_tablespaces=('MYDEFAULT')
/
select * from database_properties where property_name in ('MAX_PDB_STORAGE','MAX_SHARED_TEMP_SIZE','PATH_PREFIX','DEFAULT_PERMANENT_TABLESPACE');
alter session set container=PDB3;
alter pluggable database open;
select * from database_properties where property_name in ('MAX_PDB_STORAGE','MAX_SHARED_TEMP_SIZE','PATH_PREFIX','DEFAULT_PERMANENT_TABLESPACE');
alter pluggable database storage ( maxsize 1G max_shared_temp_size 100M );
select * from database_properties where property_name in ('MAX_PDB_STORAGE','MAX_SHARED_TEMP_SIZE','PATH_PREFIX','DEFAULT_PERMANENT_TABLESPACE');
select * from database_properties where property_name in ('MAX_PDB_STORAGE','MAX_SHARED_TEMP_SIZE','PATH_PREFIX','DEFAULT_PERMANENT_TABLESPACE');
--- # Some cleanup
alter pluggable database close immediate;
alter session set container=CDB$ROOT;
drop pluggable database PDB3 including datafiles;
--- ####################################################################
--- ### Unplug and Plug PDBs
--- ####################################################################
--- ## Unplug
alter session set container=CDB$ROOT;
alter pluggable database PDB2 close immediate;
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
alter pluggable database PDB2 unplug into '/var/tmp/PDB2.xml';
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
host cat /var/tmp/PDB2.xml
--- # The XML file has all metadata related to the PDB (which was stored in CDB$ROOT and controlfile)
host xmllint --shell /var/tmp/PDB2.xml <<<'cat /PDB/vsns'
host xmllint --shell /var/tmp/PDB2.xml <<<'cat //dbid|//cdbid|//guid'
host xmllint --shell /var/tmp/PDB2.xml <<<'cat //options'
host xmllint --shell /var/tmp/PDB2.xml <<<'cat /PDB/tablespace/file/path'
host xmllint --shell /var/tmp/PDB2.xml <<<'cat //parameters'
host xmllint --shell /var/tmp/PDB2.xml <<<'cat //services'
host xmllint --shell /var/tmp/PDB2.xml <<<'cat //sqlpatches'
host xmllint --shell /var/tmp/PDB2.xml <<<'cat //tzvers'
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
--- # If you want to plug the PDB elsewhere, you need to keep the datafiles
drop pluggable database PDB2 keep datafiles;
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
--- # Actually there's a DROPPED status (4) until some background cleanup
select name,obj#,con_id#,dbid,con_uid,c.status,postplugtime from container$ c join obj$ using(obj#) order by obj#;
--- # We can copy the files (here the goal is to plug it later from another place)
host cp -r /u01/oradata/CDB1/PDB2 /u01/oradata/CDB1/PDB5
--- ## Plug
--- # Here we will copy (the default) the datafiles referenced by the .xml to clone
create pluggable database PDB3 using '/var/tmp/PDB2.xml'
 copy file_name_convert=('/PDB2/','/PDB3/')
/
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
host du -a /u01/oradata/CDB1/PDB2
host du -a /u01/oradata/CDB1/PDB3
--- # The source files are still there (COPY is the default) and can provision another clone
create pluggable database PDB4 using '/var/tmp/PDB2.xml'
 copy file_name_convert=('/PDB2/','/PDB4/')
/
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
--- # We need to change DBID and GUID
create pluggable database PDB4 as clone using '/var/tmp/PDB2.xml'
 copy file_name_convert=('/PDB2/','/PDB4/')
/
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
--- # If the files are at their place, nocopy (and no convert)
create pluggable database PDB2 as clone using '/var/tmp/PDB2.xml'
 nocopy 
/
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
--- # We can also move files when plugging
create pluggable database PDB5 as clone using '/var/tmp/PDB2.xml'
 move file_name_convert=('/PDB2/','/PDB5/') 
/
--- # Ouch... /PDB2 files now belong to PDB2 pluggable database. Be careful!
--- remember that we did the copy into /PDB5 for files related to the unplug
--- # We can rename in .xml or convert
create pluggable database PDB5 as clone using '/var/tmp/PDB2.xml'
 source_file_name_convert=('/u01/oradata/CDB1/PDB2/','/u01/oradata/CDB1/PDB5/') nocopy
/
--- ## Open all and save state
--- # We can open all to get them to NORMAL state
alter pluggable database all open;
show pdbs
--- # If we shutdown and startup the database they will all be closed
startup force
show pdbs
--- # If we want auto start, we can save the state
alter pluggable database all open;
alter pluggable database all save state;
startup force
show pdbs
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
select * from dba_pdb_saved_states;
--- ## PDB archive, and OMF
alter pluggable database PDB5 close;
alter pluggable database PDB5 unplug into '/var/tmp/PDB5.pdb'
/
--- # Only the .xml extension is different
host file /var/tmp/PDB5.pdb
host unzip -t /var/tmp/PDB5.pdb
drop pluggable database PDB5 including datafiles;
--- # this standalone .pdb can be imported
create pluggable database PDB6 as clone using '/var/tmp/PDB5.pdb'
/
---
--- # Ok, bored with file_name_convert...
alter session set db_create_file_dest='/u01/oradata';
create pluggable database PDB6 as clone using '/var/tmp/PDB5.pdb'
/
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
select con_id,name from v$datafile order by 1,2;
--- # OMF creates a subdirectory with the GUID
--- ## Cleanup: drop all
alter pluggable database all except PDB1 close;
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
drop pluggable database PDB2 including datafiles;
drop pluggable database PDB3 including datafiles;
drop pluggable database PDB4 including datafiles;
drop pluggable database PDB6 including datafiles;
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
show pdbs
alter pluggable database PDB1 open;
--- ####################################################################
--- ### Plug in violations ( plug PDB0 )
--- ####################################################################
connect / as sysdba
show pdbs
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
select * from pdb_plug_in_violations;
--- ## Plug PDB0 from a PDB archive in /u01/app/temp/PDB0.pdb
host ls -l /u01/app/temp/PDB0.pdb
--- # Plug into CDB1 as PDB10
create pluggable database PDB10
 using '/u01/app/temp/PDB0.pdb'
/
--- # You may want to know the file names to define the file_name_convert 
---
host unzip -od /tmp /u01/app/temp/PDB0.pdb /u01/app/temp/PDB0.xml
host strings /tmp/u01/app/temp/PDB0.xml
host xmllint --shell /tmp/u01/app/temp/PDB0.xml <<<'cat //path'
--- # Try a convert from that
create pluggable database PDB10
 using '/u01/app/temp/PDB0.pdb'
 file_name_convert=('/u01/oradata/CDB1/PDB0/','/u01/oradata/CDB1/PDB10/')
/
--- # With PDB archives, the convert is relative to the xml, not to the original datafiles
create pluggable database PDB10
 using '/u01/app/temp/PDB0.pdb'
 file_name_convert=('/u01/app/temp/','/u01/oradata/CDB1/PDB10/')
/
host rman target / <<<'report schema;'
---
--- ## Open the plugged PDB10
show pdbs
select * from pdb_plug_in_violations;
alter pluggable database PDB10 open;
--- # There is a warning here
show pdbs
--- # The PDB is opened but in restricted mode
select * from pdb_plug_in_violations;
--- # We have the detail in PDB_PLUG_IN_VIOLATIONS
select status,message from pdb_plug_in_violations;
--- # The PDB is coming from a previous PSU
host $ORACLE_HOME/OPatch/datapatch
show pdbs
select * from pdb_plug_in_violations;
alter session set container=PDB10;
alter system disable restricted session;
alter pluggable database PDB10 close;
alter pluggable database PDB10 open;
show pdbs
select * from pdb_plug_in_violations;
--- # Now the violation is resolved
alter session set container=CDB$ROOT;
--- ## Be careful, there are cases where files are still open 
alter pluggable database PDB10 close;
host fuser /u01/oradata/?*
host for i in $(fuser /u01/oradata/?*) ; do ps -p $i ; done
drop pluggable database PDB10 including datafiles;
host find /proc/?*/fd -ls 2>/dev/null | grep deleted 
host df -h /u01/oradata
host find /proc/?*/fd -ls 2>/dev/null | grep -E " [/]u02[/]oradata[/].* [(]deleted[)]" | awk '{print $11}' | while read f ; do : > $f ; done
host df -h /u02/oradata
host adrci exec="set home diag/rdbms/cdb1/CDB1; show alert -tail 100"
--- ####################################################################
--- ### Snapshot Clone
--- ####################################################################
connect / as sysdba
--- # As we don't have a snapshot compatible filesystem here (ACFS, dNFS,...) we use CloneDB
show parameter clone
alter system set clonedb=true scope=spfile clonedb_dir='/u01/oradata' scope=spfile;
shutdown immediate
connect / as sysdba
startup 
show parameter clone
host ls -alrt /u01/oradata
host du -ah /u01/oradata/ | grep --color=auto bitmap
host file /u01/oradata/?*bitmap.dbf
show pdbs
host ls -alrt /u01/oradata/CDB1/PDB1
--- # Those are read only snapshots
alter pluggable database PDB1 open read only force;
host ls -alrt /u01/oradata/CDB1/PDB1
--- # Still one command, Oracle manages the snapshot depending on filesystem capabilities
create pluggable database PDB1CLONE1 from PDB1
 file_name_convert=('/PDB1/','/PDB1CLONE1/')
 snapshot copy
/
--- # We see the files with ls
host ls -alrt /u01/oradata/CDB1/PDB1
alter pluggable database PDB1CLONE1 open;
host ls -alrt /u01/oradata/CDB1/PDB1CLONE1
select con_id,con_uid,guid,name,open_mode,snapshot_parent_con_id from v$pdbs;
--- # The disk usage is low -> clonedb snapshots uses sparse file
host du -ha /u01/oradata/CDB1/PDB1
host du -ha /u01/oradata/CDB1/PDB1CLONE1
--- # Only a filesystem with write snapshot can open read write the parent
alter pluggable database PDB1 open read write force;
---# Cleanup:
alter pluggable database PDB1CLONE1 close;
drop pluggable database PDB1CLONE1 including datafiles;
alter pluggable database PDB1 close;
host chmod 640 /u01/oradata/CDB1/PDB1/?*
host ls -alrt /u01/oradata/CDB1/PDB1
alter pluggable database PDB1 open;
show pdbs
--- ####################################################################
--- ### Local Undo, PITR, Flashback PDB
--- ####################################################################
connect / as sysdba
--- ## Local undo
select * from database_properties where property_name='LOCAL_UNDO_ENABLED';
--- # If false or if not there, shared undo. Local undo is a 12.2 feature
--- ## Shared undo
alter database local undo off;
--- # This can be changed un upgrade mode only;
shutdown immediate
startup upgrade
show pdbs
alter database local undo off;
shutdown immediate
startup
--- ## Free some space in FRA and have a backup
quit
rman target /
delete noprompt archivelog all;
delete noprompt backup;
alter system set db_recovery_file_dest_size=6G scope=memory;
select v.file_type,"%","%"*space_limit/1024/1024/100 "MB" from (select (select name from v$database) database,file_type,percent_space_used-percent_space_reclaimable "%", space_limit,percent_space_used,percent_space_reclaimable from v$recovery_area_usage , v$recovery_file_dest) v;
host "df -h /u01";
backup database;
quit
--- ## Flashback PDB in shared undo
sqlcl / as sysdba
alter session set container=PDB1;
create restore point BREAK guarantee flashback database;
show con_name
shutdown immediate
startup mount
flashback pluggable database to restore point BREAK;
alter session set container=CDB$ROOT;
flashback pluggable database PDB1 to restore point BREAK;
quit
--- # Not a clean restore point, needs UNDO, this is a job for RMAN
rman target /
flashback database PDB1 to restore point BREAK;
--- # In shared UNDO a PITR or flashback database requires an auxiliary database (except for clean restore point)
quit
sqlcl / as sysdba
show pdbs
alter pluggable database PDB1 open;
alter pluggable database PDB1 open resetlogs;
alter session set container=PDB1;
drop restore point BREAK;
--- ## Change to local undo
alter session set container=CDB$ROOT;
shutdown immediate
startup upgrade
show pdbs
alter database local undo on;
shutdown immediate
startup
--- # If a PDB does not have an undo tablespace, it will be created at open
--- ## PDBPITR
connect / as sysdba
alter pluggable database all open;
create restore point BREAK;
--- #  Do some changes to see the flashback
connect scott/tiger@//localhost/PDB1
select * from EMP;
update EMP set comm=666 where ename='SCOTT';
commit;
select * from EMP;
quit
--- #  Close the PDB and flashback
rman target /
alter pluggable database PDB1 close immediate;
list restore point all;
restore pluggable database PDB1 until restore point BREAK;
alter pluggable database PDB1 open;
recover pluggable database PDB1 until restore point BREAK;
alter pluggable database PDB1 open;
alter pluggable database PDB1 open resetlogs;
drop restore point BREAK;
quit
--- #  Check that we have the previous values
sqlcl scott/tiger@//localhost/PDB1
select * from EMP;
quit
--- # Remove backups to get some space
rman target /
delete noprompt archivelog all;
delete noprompt backup;
alter system set db_recovery_file_dest_size=2G scope=memory;
select v.file_type,"%","%"*space_limit/1024/1024/100 "MB" from (select (select name from v$database) database,file_type,percent_space_used-percent_space_reclaimable "%", space_limit,percent_space_used,percent_space_reclaimable from v$recovery_area_usage , v$recovery_file_dest) v;
quit
--- # What about Begin Backup?
sqlcl / as sysdba
show pdbs
alter database begin backup;
alter pluggable database pdb1 close;
alter database end backup;
quit
--- tmux send-keys arc C-M
--- ####################################################################
--- ### Cloning among CDBs
--- ####################################################################
--- # we start the second instance
. oraenv <<< CDB2
sqlcl / as sysdba
startup
--- ## Remote clone
connect /@CDB1 as sysdba
--- # We need a user on the source.
--- # Remote clone needs CREATE PLUGGABLE DATABASE or SYSOPER on source
grant create session, create pluggable database to C##CLONE identified by oracle container=all;
connect /@CDB2 as sysdba
exec begin execute immediate 'drop database link CDB1'; exception when others then null; end;
--- # You can add an entry to the wallet if you want to use external password
create database link CDB1 connect to C##CLONE identified by oracle using 'CDB1'
/
select * from dual@CDB1;
--- # Check some data on source
connect scott/tiger@//localhost/PDB1
select * from emp where ename='KING';
--- # Clone (no need to have the source read only in 12.2 local undo)
connect /@CDB2 as sysdba
create pluggable database PDB1BIS from PDB1@CDB1
 file_name_convert=('/CDB1/PDB1/','/CDB2/PDB1BIS/')
/
show pdbs
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
--- # open the PDB
alter pluggable database PDB1BIS open;
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
show pdbs
--- ## Refreshable clone 
--- # Check some data on source
connect scott/tiger@//localhost/PDB1
select * from emp where ename='KING';
--- # Clone (no need to have the source read only in 12.2 local undo)
connect /@CDB2 as sysdba
create pluggable database PDB1MAN from PDB1@CDB1
 file_name_convert=('/CDB1/PDB1/','/CDB2/PDB1MAN/')
 refresh mode manual
/
show pdbs
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
--- # We can't open a refreshable PDB read write
alter pluggable database PDB1MAN open;
show pdbs
--- # We can open it read-only (for example to thin clone on a read-write snapshot filesystem)
alter pluggable database PDB1MAN open read only;
show pdbs
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
select * from dba_plug_in_violations;
alter session set container=PDB1MAN;
select * from SCOTT.EMP;
--- # Updating the source
connect scott/tiger@//localhost/PDB1
update emp set sal=5555 where ename='KING';
commit;
select * from emp where ename='KING';
--- # To refresh it, we have to close it
connect /@CDB2 as sysdba
alter pluggable database PDB1MAN close;
alter pluggable database PDB1MAN refresh;
alter session set container=PDB1MAN;
alter pluggable database PDB1MAN refresh;
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
alter pluggable database PDB1MAN open read only;
select * from SCOTT.EMP;
--- # we can schedule the refresh
alter pluggable database PDB1MAN refresh mode every 5 minutes;
--- # we have to close it to be refreshed
alter pluggable database PDB1MAN close;
connect scott/tiger@//localhost/PDB1
variable j number
exec dbms_job.submit(:j,q'[begin update SCOTT.EMP set sal=sal+1 where ename='KING'; commit; end;]',sysdate,'sysdate+1/1440'); commit;
--- # get back after a while to see the update...
connect /@CDB2 as sysdba
alter pluggable database PDB1MAN open read only;
connect scott/tiger@//localhost/PDB1MAN
select * from EMP;
connect /@CDB2 as sysdba
alter pluggable database PDB1MAN close;
--- ## relocate database
connect /@CDB2 as sysdba
create pluggable database PDB1 from PDB1@CDB1
 file_name_convert=('/CDB1/PDB1/','/CDB2/PDB1/')
 relocate 
/
--- # relocate needs SYSOPER on source
connect /@CDB1 as sysdba
grant sysoper to C##CLONE identified by oracle container=all;
connect /@CDB2 as sysdba
create pluggable database PDB1 from PDB1@CDB1
 file_name_convert=('/CDB1/PDB1/','/CDB2/PDB1/')
 relocate 
/
show pdbs
host lsnrctl status | grep -A 3 --color=auto '"pdb1"'
--- # the listener knows both instances, be the PDB is opened on CDB1 only
host sqlplus -l scott/tiger@//localhost:1521/PDB1:DEDICATED/CDB1 <<< ''
host sqlplus -l scott/tiger@//localhost:1521/PDB1:DEDICATED/CDB2 <<< ''
--- # you need an address list to connect to the right destination
quit
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
--- # In another terminal, connect to PDB1
--- tmux resize-pane -Z -t :.0
--- tmux select-pane -t :.1
sqlplus -l scott/tiger@//localhost:1521/PDB1:DEDICATED/CDB1
set linesize 120
select * from EMP where ename='KING';
update EMP set COMM=0 where ENAME='KING';
commit;
update EMP set COMM=1 where ENAME='KING';
select * from EMP where ename='KING';
--- # leave the transaction opened and return to the first terminal
--- tmux select-pane -t :.0
--- # time to relocate
connect /@CDB2 as sysdba
show pdbs
alter pluggable database PDB1 open;
--- # check where the service is declared
host lsnrctl status | grep -A 3 --color=auto '"pdb1"'
--- # back to the session in CDB1 and try to commit;
--- tmux select-pane -t :.1
commit;
--- # the sessions can now failover to new location
connect scott/tiger@//localhost/PDB1
--- # the committed changes are there
select ename,comm from EMP where ENAME='KING';
quit
--- # back on session 1
--- tmux resize-pane -Z -t :.0
--- # check alert logs. Recovery on CDB2 at open:
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
--- # sessions have been killed on CDB1
host adrci exec="set home diag/rdbms/cdb1/CDB1; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
--- # rename PDB
show pdbs
alter pluggable database PDB1BIS rename global_name to PDB1DEV;
alter session set container=PDB1BIS;
alter pluggable database PDB1BIS rename global_name to PDB1DEV;
alter system enable restricted session;
alter pluggable database PDB1BIS rename global_name to PDB1DEV;
show con_name
alter system disable restricted session;
--- # some cleanup
alter session set container=CDB$ROOT;
show pdbs
drop pluggable database PDB1MAN including datafiles;
alter pluggable database PDB1DEV close;
drop pluggable database PDB1DEV including datafiles;
--- # PDB1 back to CDB1 in availability max
connect /@CDB2 as sysdba
grant create session, sysoper to C##CLONE identified by oracle container=all;
connect /@CDB1 as sysdba
create database link CDB2 connect to C##CLONE identified by oracle using 'CDB2';
create pluggable database PDB1 from PDB1@CDB2
 file_name_convert=('/CDB2/PDB1/','/CDB1/PDB1/')
 relocate availability max
/
alter pluggable database PDB1 open
/
show pdbs
--- # with availability max the source was not dropped
host lsnrctl status | grep -A 3 --color=auto '"pdb1"'
--- # we can connect to both but all go to CDB1
quit
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
sqlplus -L scott/tiger@//localhost/PDB1 <<<'select instance_name from v$instance;'
--- # on source, the PDB1 is not open
sqlcl /nolog
connect /@CDB2 as sysdba
show pdbs
--- # a tombstone has been left to relocate
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
-- # you can drop the tombstone when you are sure all client conneciton strings are ok
alter session set container=PDB1;
show con_id
select * from dual;
alter session set container=CDB$ROOT;
drop pluggable database PDB1 including datafiles;
--- # proxy PDB
show pdbs
create pluggable database PDB1PROXY as proxy from PDB1@CDB1
  file_name_convert=('/CDB1/PDB1/','/CDB2/PDB1PROXY/')
/
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
alter pluggable database PDB1PROXY open;
select pdb_id,pdb_name,dbid,con_uid,guid,status,con_id from dba_pdbs order by creation_time;
select instance_name from v$instance;
alter session set container=PDB1PROXY;
select instance_name from v$instance;
connect scott/tiger@//localhost/PDB1PROXY
select instance_name from v$instance;
select name from v$datafile;
host du -ah /u01/oradata | grep --color=auto -E "PDB1(PROXY)?"
exec sys.dbms_feature_usage_internal.exec_db_usage_sampling(sysdate); commit;
select * from dba_feature_usage_statistics;
--- ## Cross-CDB queries
connect /@CDB2 as sysdba
select dbid,name,con_id,current_scn,cdb  from containers(v$database);
select ksppinm,ksppstvl,ksppdesc,ksppstdfl from x$ksppi join x$ksppsv using(indx) where ksppinm like '%view_pdb%';
quit
. oraenv <<<CDB1
--- tmux send-keys arc C-M
--  ####################################################################
--- ### Performance
--- ####################################################################
--- ## AWR at CDB and PDB level
sqlcl sys/oracle@//localhost/CDB1 as sysdba
@?/rdbms/admin/awrrpt
text
1
2
3
awrrpt_CDB1_1_2_3.txt
host head -30 awrrpt_CDB1_1_2_3.txt | grep -E --color=auto ".*mins.|^"
--- # By default all snapshots are on CDB
alter session set container=PDB1;
@?/rdbms/admin/awrrpt
text
AWR_PDB
--- # We can create manual snapshots on PDB
sqlcl sys/oracle@//localhost/PDB1 as sysdba
exec dbms_workload_repository.create_snapshot;
exec begin for i in 1..6e6 loop dbms_output.put('.') ; end loop; end;
exec dbms_workload_repository.create_snapshot;
@?/rdbms/admin/awrrpt
text
AWR_PDB
1
1
2
awrrpt_PDB1_1_2_3.txt
host head -30 awrrpt_PDB1_1_2_3.txt | grep -E --color=auto ".*mins.|^"
--- ## Resource manager
alter session set container=PDB1;
show con_name
select plan,cpu_method from dba_rsrc_plans;
alter system set resource_manager_plan='DEFAULT_PLAN';
alter system set cpu_count=2;
quit
--- # in another terminal run oratop
--- tmux resize-pane -Z -t :.0
--- tmux select-pane -t :.1
$ORACLE_HOME/suptools/oratop/oratop -f / as sysdba
--- # back to first terminal, run 5 concurrent sessions on CPU for PDB1
--- tmux select-pane -t :.0
for i in {1..5} ; do sqlplus sys/oracle@//localhost/PDB1 as sysdba <<< "exec begin for i in 1..1e8 loop dbms_output.put('.') ; end loop; end;" & done
for i in {1..5} ; do sqlplus sys/oracle@//localhost/CDB1 as sysdba <<< "exec begin for i in 1..1e8 loop dbms_output.put('.') ; end loop; end;" & done
--- tmux resize-pane -Z -t :.0
--- ####################################################################
--- ### TDE Encryption
--- ####################################################################
--- # If we still have clonedb=true, may be better to remove it now
alter system set clonedb=false scope=spfile;
shutdown immediate
startup
quit
--- # re-create PDB1 just in case
sqlcl / as sysdba
show pdbs
alter pluggable database PDB1 close;
drop pluggable database PDB1 including datafiles;
create pluggable database PDB1 admin user pdbadmin identified by oracle role=(DBA) file_name_convert=('pdbseed','PDB1') default tablespace USERS datafile '/u01/oradata/CDB1/PDB1/users.dbf' size 10M autoextend on next 10M maxsize unlimited;
alter pluggable database PDB1 open;
alter pluggable database PDB1 save state;
host TWO_TASK=//localhost/PDB1 sqlplus sys/oracle as sysdba @ ?/rdbms/admin/utlsampl
quit
--- ## encryption keystore is at CDB level (12c)
mkdir -p /u01/app/TDE/CDB1 /u01/app/TDE/CDB2
echo 'ENCRYPTION_WALLET_LOCATION=(SOURCE=(METHOD=FILE)(METHOD_DATA=(DIRECTORY=/u01/app/TDE/$ORACLE_SID)))' >> ${TNS_ADMIN:-$ORACLE_HOME/network/admin}/sqlnet.ora
--- # we use the ORACLE_SID in the path
grep --color=auto -E ".*WALLET|.ORACLE_SID" ${TNS_ADMIN:-$ORACLE_HOME/network/admin}/sqlnet.ora
sqlcl / as sysdba
select * from v$encryption_wallet;
host du -a /u01/app/TDE
--- # Create the wallet for CDB1
administer key management
 create keystore '/u01/app/TDE/CDB1' identified by "k3yCDB1"
/
select * from v$encryption_wallet;
--- # Open the wallet (with password)
administer key management set keystore open identified by "k3yCDB1" container=current
/
select * from v$encryption_wallet;
--- # Create the masterkey for CDB$ROOT
administer key management set key using tag 'cdb1' identified by "k3yCDB1" with backup container=current
/
select * from v$encryption_wallet;
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
--- ## PDB master key 
show pdbs
alter session set container=PDB1;
startup
--- # We have not open the wallet in the PDB (could have done it with container=all=
alter tablespace USERS encryption encrypt file_name_convert=('.dbf','.tde')
/
select * from v$encryption_wallet;
administer key management set keystore open identified by "k3yCDB1"
/
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
--- # W have no master key in the PDB
administer key management set key using tag 'pdb1' identified by "k3yCDB1" with backup container=current
/
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
--- # Encrypt a tablespace
alter tablespace USERS encryption encrypt file_name_convert=('.dbf','.tde')
/
--- # From root we see all keys
alter session set container=CDB$ROOT;
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
--- # If the database is restarted
startup force
connect / as sysdba
show pdbs
alter pluggable database all open;
--- # We need to open the wallet
select * from v$encryption_wallet;
administer key management set keystore open identified by "k3yCDB1" 
 --container=all
/
select * from v$encryption_wallet;
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
alter database open;
alter pluggable database all open;
alter pluggable database all save state;
alter session set container=PDB1;
select * from SCOTT.DEPT;
select * from v$encrypted_tablespaces;
create table SCOTT.DEPT2 tablespace users as select * from SCOTT.DEPT;
select con_id,ts#, encryptionalg,masterkeyid,encryptedts,blocks_encrypted,blocks_decrypted from v$encrypted_tablespaces;
select encryptionalg,masterkeyid,con_id from v$database_key_info;
--- # (Bug?) we don't see the wallet opened
select * from v$encryption_wallet;
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
alter session set container=CDB$ROOT;
select * from v$encryption_wallet;
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
select encryptionalg,masterkeyid,con_id from v$database_key_info;
select con_id,ts#, encryptionalg,masterkeyid,encryptedts,blocks_encrypted,blocks_decrypted from v$encrypted_tablespaces;
--- ## Create an autologin wallet
shutdown immediate
startup
connect / as sysdba
select * from v$encryption_wallet;
administer key management create auto_login keystore 
  from keystore '/u01/app/TDE/CDB1' identified by "k3yCDB1"
/
select * from v$encryption_wallet;
alter session set container=PDB1;
select * from v$encryption_wallet;
--- ## Creating a new PDB
alter session set container=CDB$ROOT;
create pluggable database PDB6 from PDB1 file_name_convert=('/PDB1/','/PDB6/')
/
create pluggable database PDB6 from PDB1 file_name_convert=('/PDB1/','/PDB6/')
 keystore identified by "k3yCDB1"
/
alter pluggable database PDB6 open
/
alter session set container=PDB6;
select * from SCOTT.DEPT;
--- ## Clone to CDB2
connect /@CDB2 as sysdba
create pluggable database PDB7 from PDB1@CDB1 
 file_name_convert=('/CDB1/PDB1/','/CDB2/PDB7/')
/
--- # We need a wallet for CDB2
administer key management create keystore '/u01/app/TDE/CDB2' identified by "k3yCDB2";
administer key management set keystore open identified by "k3yCDB2";
administer key management set key using tag 'cdb2' identified by "k3yCDB2" with backup container=current;
select * from v$encryption_wallet;
create pluggable database PDB7 from PDB1@CDB1 
 file_name_convert=('/CDB1/PDB1/','/CDB2/PDB7/')
 keystore identified by "k3yCDB2"
/
--- # note that we didn't mention the source password
alter pluggable database PDB7 open;
alter session set container=PDB7;
select * from SCOTT.DEPT;
administer key management set keystore open identified by "k3yCDB2";
select * from SCOTT.DEPT;
select * from v$encryption_wallet;
select con_id,tag,substr(key_id,1,6)||'...' "KEY_ID...",creator,key_use,keystore_type,origin,creator_pdbname,activating_pdbname from v$encryption_keys;
select encryptionalg,masterkeyid,con_id from v$database_key_info;
select con_id,ts#, encryptionalg,masterkeyid,encryptedts,blocks_encrypted,blocks_decrypted from v$encrypted_tablespaces;
--- # the key has been imported automatically
--- ## Plug to CDB2
connect /@CDB1 as sysdba
show pdbs
alter pluggable database PDB6 close immediate;
alter pluggable database PDB6 unplug into '/var/tmp/PDB6.xml';
--- # master keys of the PDB must be exported
alter pluggable database PDB6 open;
alter session set container=PDB6;
administer key management set keystore open identified by "k3yCDB1";
alter session set container=CDB$ROOT;
administer key management set keystore close;
administer key management set keystore open identified by "k3yCDB1";
alter session set container=PDB6;
administer key management set keystore open identified by "k3yCDB1";
administer key management
 export encryption keys with secret "this is my secret password for the export"
 to '/var/tmp/PDB6.p12'
 identified by "k3yCDB1"
/
alter session set container=CDB$ROOT;
alter pluggable database PDB6 close immediate;
alter pluggable database PDB6 unplug into '/var/tmp/PDB6.xml';
connect /@CDB2 as sysdba
create pluggable database PDB6 using '/var/tmp/PDB6.xml' file_name_convert=('/CDB1/PDB6/','/CDB2/PDB6/');
select * from pdb_plug_in_violations;
alter session set container=PDB6;
alter pluggable database open;
select * from SCOTT.EMP;
administer key management set keystore open identified by "k3yCDB2";
administer key management
 import encryption keys with secret "this is my secret password for the export"
 from '/var/tmp/PDB6.p12'
 identified by "k3yCDB2"
 with backup
/
alter session set container=CDB$ROOT;
show pdbs
alter pluggable database PDB6 close;
alter pluggable database PDB6 open;
show pdbs
alter session set container=PDB6;
administer key management set keystore open identified by "k3yCDB2";
select * from SCOTT.EMP;
--- # check one_step_plugin_for_pdb_with_tde
quit
---
--- ####################################################################
--- ### Data Guard
--- ####################################################################
--- ## quickly re-create CDB2 as a CDB1 standby (nothing multitenant specific here - you can run /u01/app/temp/dataguard.sh)
--- # prepare CDB1
. oraenv <<< CDB1
sqlcl / as sysdba 
alter system set db_file_name_convert='CDB2','CDB1' scope=spfile;
alter system set log_file_name_convert='CDB2','CDB1' scope=spfile;
alter system set db_recovery_file_dest_size=2G;
alter system set dg_broker_start=true;
alter database add standby logfile thread 1 group 4 size 200M;
alter database add standby logfile thread 1 group 5 size 200M;
alter database add standby logfile thread 1 group 6 size 200M;
alter database add standby logfile thread 1 group 7 size 200M;
select group#,thread#,bytes,blocksize from v$log;
select group#,thread#,bytes,blocksize from v$standby_log;
quit
--- # prepare CDB2
. oraenv <<< CDB2
sqlcl / as sysdba 
startup nomount force
alter system set db_name=CDB1 scope=spfile;
alter system set db_file_name_convert='CDB1','CDB2' scope=spfile;
alter system set log_file_name_convert='CDB1','CDB2' scope=spfile;
alter system set db_recovery_file_dest_size=2G;
startup nomount force;
alter system set dg_broker_start=true;
quit
rm -rf /u01/fast_recovery_area/CDB2 /u01/oradata/CDB2
mkdir -p /u01/fast_recovery_area/CDB2 /u01/oradata/CDB2
du /u01/oradata/CDB1 | sed -e 's/CDB1/CDB2/' | while read x d ; do mkdir -p "$d" ; done
--- # duplicate CDB1 to CDB2
rman
connect target sys/oracle@//localhost/CDB1_DGMGRL
connect auxiliary sys/oracle@//localhost/CDB2_DGMGRL
delete noprompt archivelog all;
duplicate target database for standby from active database using copy;
quit
--- # create DGB configuration
. oraenv <<< CDB1
dgmgrl sys/oracle 
create configuration CDB as primary database is CDB1 connect identifier is '//localhost/CDB1_DGMGRL';
add database CDB2 as connect identifier is '//localhost/CDB2_DGMGRL';
edit database CDB1 set property LogXptMode='SYNC';
edit database CDB2 set property LogXptMode='SYNC';
edit database CDB1 set property StandbyFileManagement='AUTO';
edit database CDB2 set property StandbyFileManagement='AUTO';
edit database CDB1 set property StaticConnectIdentifier='(DESCRIPTION=(CONNECT_DATA=(SERVICE_NAME=CDB1_DGMGRL)(INSTANCE_NAME=CDB1))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521)))';
edit database CDB2 set property StaticConnectIdentifier='(DESCRIPTION=(CONNECT_DATA=(SERVICE_NAME=CDB2_DGMGRL)(INSTANCE_NAME=CDB2))(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521)))';
show database verbose CDB2;
enable configuration;
show configuration;
show database verbose CDB1;
show database verbose CDB2;
quit
--- # if CDB is in TDE, copy the wallet
tail -20 /u01/app/oracle/diag/rdbms/cdb2/CDB2/trace/alert_CDB2.log
host du -a /u01/app/TDE
cp -r /u01/app/TDE/CDB1/?* /u01/app/TDE/CDB2
. oraenv <<<CDB2
sqlcl / as sysdba
shutdown immediate
startup
connect / as sysdba
select facility,substr(severity,1,8) severity,error_code err,callout,timestamp,substr(message,1,40) from v$dataguard_status order by message_num;
select source_db_unique_name,name,value,time_computed,unit from v$dataguard_stats;
quit
--- # retention policy
. oraenv <<<CDB2
rman target / <<<'configure archivelog deletion policy to applied on all standby;'
. oraenv <<<CDB1
rman target / <<<'configure archivelog deletion policy to applied on all standby;'
--- # test switchover
dgmgrl sys/oracle
validate database CDB2;
switchover to CDB2;
switchover to CDB1;
quit
for i in CDB1 CDB2 ; do sqlplus /@$i as sysdba <<< 'select name,open_mode,database_role from v$database;' ; done
--- ## Do some PDB cloning in CDB1 with CDB2 in mount (no ADG)
sqlcl /@CDB1 as sysdba
show pdbs
create pluggable database PDB8 admin user pdbadmin identified by oracle
 file_name_convert=('/pdbseed/','/PDB8/')
/
alter pluggable database PDB8 open;
create pluggable database PDB9 from PDB8
 file_name_convert=('/PDB8/','/PDB9/')
 standbys = none
/
alter pluggable database PDB9 open;
show pdbs
--- ## Set parameter for ADG
connect sys/oracle@//localhost/PDB8 as sysdba
show parameter optimizer_adaptive_statistics
alter system set optimizer_adaptive_statistics=true scope=spfile db_unique_name='CDB2';
shutdown immediate
startup
show parameter optimizer_adaptive_statistics
show spparameter optimizer_adaptive_statistics
select * from pdb_spfile$;
alter session set container=CDB$ROOT;
select * from pdb_spfile$;
--- ##  Check on Standby
connect /@CDB2 as sysdba
show pdbs
host adrci exec="set home diag/rdbms/cdb2/CDB2; show alert -tail 100" | grep --color -E "(^Completed:|^alter pluggable.*|^create pluggable.*|Media Recovery|onlined Undo|KILL|^Pluggable.*|SCN [0-9]*|^)"
--- ## Set parameter for ADG
select open_mode from v$database;
alter database open read only;
select open_mode from v$database;
show pdbs
alter pluggable database all except PDB9 open read only;
show pdbs
select * from pdb_spfile$;
alter session set container=PDB8;
show parameter optimizer_adaptive_statistics;
--- # look at PDB9 (excluded from standby)
alter session set container=CDB$ROOT;
alter pluggable database PDB9 open read only;
quit
--- # you can also test unplug/plug
--- ## Do some PDB cloning in CDB1 with CDB2 open in mount
--- ####################################################################
--- ### Create a non-CDB and plug it to CDB1
--- ####################################################################
--- # delete the old CDB2
$ORACLE_HOME/bin/dbca -silent -deleteDatabase -sourceDB CDB2 -forceArchiveLogDeletion -sysDBAPassword oracle -sysDBAUserName sys
--- # do some cleanup
. oraenv <<< CDB1
rman target /
alter pluggable database PDB6 close immediate force;
alter pluggable database PDB8 close immediate force;
alter pluggable database PDB9 close immediate force;
drop pluggable database PDB6 including datafiles;
drop pluggable database PDB8 including datafiles;
drop pluggable database PDB9 including datafiles;
delete noprompt backup;
delete noprompt archivelog all;
quit
--- # quickly create a non-CDB (-createAsContainerDatabase false)
$ORACLE_HOME/bin/dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName ORCL -sid ORCL -initParams shared_pool_size=600M,local_listener='(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))' -createAsContainerDatabase false -sysPassword oracle -systemPassword oracle -emConfiguration EMEXPRESS -datafileDestination /u01/oradata -recoveryAreaDestination /u01/fast_recovery_area -recoveryAreaSize 1024 -storageType FS -sampleSchema true -automaticMemoryManagement false -totalMemory 1024 -databaseType OLTP -enableArchive false
--- ## Unplug the non-CDB
--- # open it read only
. oraenv <<< ORCL
sqlcl / as sysdba 
shutdown immediate
--- # it can be a good idea to take a backup at this point
startup mount
alter database open read only;
--- # 'unplug' it
exec dbms_pdb.describe(pdb_descr_file=>'/var/tmp/ORCL.xml')
shutdown immediate
quit
--- ## Plug the non-CDB as a PDB
--- # plug it to CDB1
. oraenv <<< CDB1
sqlcl / as sysdba 
show pdbs
create pluggable database PDBORCL using '/var/tmp/ORCL.xml'
 move file_name_convert=('/u01/oradata/ORCL/','/u01/oradata/CDB1/PDBORCL/')
/
show pdbs
--- # you need to convert the non-CDB dictionary to metadata/data links
select * from pdb_plug_in_violations;
alter pluggable database PDBORCL open;
select * from pdb_plug_in_violations;
show pdbs
alter session set container=PDBORCL;
select sum(bytes)/power(1024,2) from dba_segments where tablespace_name in ('SYSTEM','SYSAUX');
@ ?/rdbms/admin/noncdb_to_pdb.sql
select sum(bytes)/power(1024,2) from dba_segments where tablespace_name in ('SYSTEM','SYSAUX');
show pdbs
alter pluggable database PDBORCL close;
alter pluggable database PDBORCL open;
show pdbs
select * from pdb_plug_in_violations;
quit
--- ####################################################################
--- ### Create with command line
--- ####################################################################
--- # drop the unused ones
grep ^CDB2: /etc/oratab && $ORACLE_HOME/bin/dbca -silent -deleteDatabase -sourceDB CDB2 -forceArchiveLogDeletion -sysDBAPassword oracle -sysDBAUserName sys
--- ## Instance and CREATE DATABASE
--- # SID
export ORACLE_SID=MYCDB
cd $ORACLE_HOME/dbs
--- # password file
orapwd file=orapw$ORACLE_SID force=Y password=Welcome1!
--- # init.ora
cp init.ora init$ORACLE_SID.ora
sed -i -e"s?<ORACLE_BASE>?/u01/app/temp?" init$ORACLE_SID.ora
sed -i -e"s?ORCL?$ORACLE_SID?i" init$ORACLE_SID.ora
sed -i -e"s?^compatible?#&?" init$ORACLE_SID.ora
sed -i -e"s?^memory_target=?sga_target=?" init$ORACLE_SID.ora
sed -i -e"s?ora_control.?/u01/app/temp/MYCDB/&.dbf?g" init$ORACLE_SID.ora
echo db_create_file_dest='/u01/app/temp/oradata' >> init$ORACLE_SID.ora
echo db_create_online_log_dest_1='/u01/app/temp/MYCDB' >> init$ORACLE_SID.ora
echo db_create_online_log_dest_2='/u01/app/temp/MYCDB' >> init$ORACLE_SID.ora
cat init$ORACLE_SID.ora
rm -rf /u01/app/temp/MYCDB
mkdir -p /u01/app/temp/MYCDB/adump /u01/app/temp/fast_recovery_area /u01/app/temp/MYCDB /u01/app/temp/MYCDB/pdbseed
--- # instance must allow multitenant
echo enable_pluggable_database=true >> init$ORACLE_SID.ora
--- # the create database statement based on doc
sqlplus / as sysdba
startup nomount force
create database MYCDB
  user sys identified by "Welcome1!"
  user system identified by "Welcome1!"
  logfile group 1 ('/u01/app/temp/MYCDB/redo01a.dbf','/u01/app/temp/MYCDB/redo01b.dbf')
             size 100m blocksize 512,
          group 2 ('/u01/app/temp/MYCDB/redo02a.dbf','/u01/app/temp/MYCDB/redo02b.dbf')
             size 100m blocksize 512,
          group 3 ('/u01/app/temp/MYCDB/redo03a.dbf','/u01/app/temp/MYCDB/redo03b.dbf')
             size 100m blocksize 512
  maxloghistory 1
  maxlogfiles 16
  maxlogmembers 3
  maxdatafiles 1024
  character set al32utf8
  national character set al16utf16
  extent management local
  datafile '/u01/app/temp/MYCDB/system01.dbf'
    size 700m reuse autoextend on next 10240k maxsize unlimited
  sysaux datafile '/u01/app/temp/MYCDB/sysaux01.dbf'
    size 550m reuse autoextend on next 10240k maxsize unlimited
  default tablespace deftbs
     datafile '/u01/app/temp/MYCDB/deftbs01.dbf'
     size 500m reuse autoextend on maxsize unlimited
  default temporary tablespace tempts1
     tempfile '/u01/app/temp/MYCDB/temp01.dbf'
     size 20m reuse autoextend on next 640k maxsize unlimited
  undo tablespace undotbs1
     datafile '/u01/app/temp/MYCDB/undotbs01.dbf'
     size 200m reuse autoextend on next 5120k maxsize unlimited
  enable pluggable database
    seed
    file_name_convert = ('/u01/app/temp/MYCDB/',
                         '/u01/app/temp/MYCDB/pdbseed/')
    system datafiles size 125m autoextend on next 10m maxsize unlimited
    sysaux datafiles size 100m
  user_data tablespace usertbs -- to replace automatic creation of USERS in SEED
    datafile '/u01/app/temp/MYCDB/pdbseed/usertbs01.dbf'
    size 200m reuse autoextend on maxsize unlimited;
--- ## CATCON (catalog, catproc,...)
@?/rdbms/admin/catcdb.sql /var/tmp catcdbMYCDB.log
--- # Bug 25810263 - util.pm is missing under OH/rdbms/admin and running catcdb.sql fails with error (Doc ID 25810263.8)
--- # but you see the idea...
quit
--- # catcon is the tool used to run scripts in all PDBs
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -h
--- # catalog.sql
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -u sys/Welcome1! -d $ORACLE_HOME/rdbms/admin -b catalog.log -e -l /var/tmp catalog.sql
ls -alrt /var/tmp
--- # catproc.sql
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -u sys/Welcome1! -d $ORACLE_HOME/rdbms/admin -b catproc.log -e -l /var/tmp catproc.sql
ls -alrt /var/tmp
--- # pupbld.sql
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -u system/Welcome1! -d $ORACLE_HOME/rdbms/admin -b pupbld.log -e -l /var/tmp pupbld.sql
ls -alrt /var/tmp
--- # Here are the files
rman target / <<< 'report schema;'
--- ## Plug the PDB0
sqlcl / as sysdba
select * from dba_registry;
---
create pluggable database PDB0
 using '/u01/app/temp/PDB0.pdb'
 file_name_convert=('/u01/app/temp/','/u01/app/temp/MYCDB/PDB0/')
/
alter pluggable database PDB0 open;
host $ORACLE_HOME/OPatch/datapatch
alter pluggable database PDB0 close;
alter pluggable database PDB0 open;
show pdbs
select * from pdb_plug_in_violations;
--- # You can add components to the PDB, move to LOCAL UNDO...
--- ####################################################################
--- ### Catcon and Catctl
--- ####################################################################
--- ## Run a script in a PDB with catcon
. oraenv <<<CDB1
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 2 -d $ORACLE_HOME/rdbms/admin -l /var/tmp -c PDB1 -b spcreate.log spcreate.sql
--- ## Look at dbupgrade
set -x
dbupgrade
---
--- ####################################################################
--- ### application containers
--- ####################################################################
--- ## Creation of application root
connect /@CDB1 as sysdba
show con_name
show user
--- # define db_create_file_dest (OMF is highly recommended for application containers)
show parameter db_create_file_dest
--- # if not set, set it
alter system set db_create_file_dest='/u01/oradata';
--- # 'show pdbs' list containers (from v$containers)
show pdbs
--- # we have more info there about application containers
--- # define the SQLcl alias:
alias showappcon=
 select con_id, name,open_mode, restricted R, 
  application_root app_root, application_pdb app_pdb,pdb_count,
  application_root_con_id root_con_id,application_seed app_seed,
  application_root_clone root_clone,proxy_pdb proxy
  from v$containers order by creation_time;
--- # run the alias to display containers:
showappcon 
--- # application containers start with an application root
create pluggable database MYAPP_ROOT as application container 
 admin user admin identified by oracle roles=(DBA)
/
showappcon
--- # we open the application root
alter pluggable database MYAPP_ROOT open;
showappcon
--- ## Installation of the application
--- # we can now connect to our application root
connect sys/oracle@//localhost/MYAPP_ROOT as sysdba
show con_name
show user
--- # the application installation starts here
select * from dba_applications;
alter pluggable database application MYAPP begin install '1.0';
select * from dba_applications;
--- # users
grant connect,resource,create view,unlimited tablespace, select any dictionary to MYAPP_OWNER identified by oracle container=all;
--- # tablespaces
create tablespace MYAPP datafile size 10M autoextend on next 10M maxsize 100M;
---# now we can connect to the schema owner
connect MYAPP_OWNER/oracle@//localhost/MYAPP_ROOT
show con_name
show user
--- # tables (as we are on root they will be metadata link by default)
create table SALES(SALE_ID number generated as identity primary key, SALE_DATE date, PRODUCT_ID number, QUANTITY number);
--- # reference tables that are common (stored in root only)
create table PRODUCTS sharing=data (PRODUCT_ID number primary key, PRODUCT_NAME varchar2(20));
insert into PRODUCTS values(1,'product1');
insert into PRODUCTS values(2,'product2');
insert into PRODUCTS values(3,'product3');
commit;
exec dbms_stats.gather_table_stats('MYAPP_OWNER','PRODUCTS');
--- # constraints
/* there is a bug with foreign keys to data links
alter table SALES add constraint SALES_PRODUCT foreign key(PRODUCT_ID) references PRODUCTS(PRODUCT_ID);
*/
--- # procedures
create procedure NEW_SALE(product_id number, quantity number) as begin
 insert into SALES(product_id,sale_date,quantity) values (product_id,sysdate,quantity);
 commit;
end;
/
--- # views
create view SALES_INFO as 
 select * from PRODUCTS left outer join SALES using(PRODUCT_ID)
/
--- # the application installation ends here
connect sys/oracle@//localhost/MYAPP_ROOT as sysdba
select * from dba_applications;
alter pluggable database application MYAPP end install '1.0';
select * from dba_applications;
--- # the statements have been recorded
select origin_con_id con_id,statement_id,app_name,app_status,patch_number,
 substr(replace(app_statement,chr(10),' '),1,50) app_statement
from dba_app_statements where app_name='MYAPP' order by statement_id
/
select opcode,flags,appid#,ver#,patch#,app_status,replay#,name,sqlid,
 substr(replace(sqlstmt,chr(10),' '),1,18) sqlstmt
from pdb_sync$ order by replay#,opcode desc
/
--- ## we create a seed to provision the application PDBs
show con_name
show user
create pluggable database as seed admin user admin identified by oracle roles=(DBA) 
/
showappcon
alter pluggable database MYAPP_ROOT$SEED open;
--- # we are in the root, with the users created there
select username,account_status,common,inherited,implicit from dba_users where oracle_maintained='N';
connect sys/oracle@//localhost/MYAPP_ROOT$SEED as sysdba
--- # the PDB admin user is there, but not those created by our application
select tablespace_name,file_name,file_id from dba_data_files;
select username,account_status,common,inherited,implicit from dba_users where oracle_maintained='N';
--- # we need to sync to get the application install replayed here
alter pluggable database application MYAPP sync;
select tablespace_name,file_name,file_id from dba_data_files;
select username,account_status,common,inherited,implicit from dba_users where oracle_maintained='N';
select object_id,owner,object_name,object_type,sharing from dba_objects where owner='MYAPP_OWNER' order by object_id;
--- ## more details from the dictionary views
--- # tables and procedures are metadata links
select obj#,obj$.type#,obj$.name,tab$.cols from obj$ left outer join tab$ using(obj#) 
where obj$.type#=2 and owner#=(select user_id from dba_users where username='MYAPP_OWNER')
/
select obj#,obj$.type#,obj$.name,ind$.cols from obj$ left outer join ind$ using(obj#) 
where obj$.type#=1 and owner#=(select user_id from dba_users where username='MYAPP_OWNER')
/
select obj#,obj$.type#,obj$.name,highwater from obj$ left outer join seq$ using(obj#) 
where obj$.type#=6 and owner#=(select user_id from dba_users where username='MYAPP_OWNER')
/
--- # table related metadata is replicated locally, but source of procedures and views is not:
select obj#,obj$.type#,obj$.name,source$.line,source$.source from obj$ left outer join source$ using(obj#) 
where obj$.type#=7 and owner#=(select user_id from dba_users where username='MYAPP_OWNER')
/
select obj#,obj$.type#,obj$.name,view$.cols,view$.text from obj$ left outer join view$ using(obj#) 
where obj$.type#=4 and owner#=(select user_id from dba_users where username='MYAPP_OWNER')
/
--- # however, metadata is accesible
ddl MYAPP_OWNER.NEW_SALE 
ddl MYAPP_OWNER.SALES_INFO
--- # Bug 22278117 - APP PDB : ORA-31603 ON PERFORMING SYNC OPERATION It was closed as not a bug and Development team has provided the below explination: "Getting metadata in a PDB for an shared object (defined in the cdb root, or approot if the pdb is an app pdb) is not supported; we have no good mechanism for this. 
---
--- # about data, only data links have data
select * from MYAPP_OWNER.SALES;
---
select * from dbms_xplan.display_cursor(format=>'basic +rows');
select * from MYAPP_OWNER.PRODUCTS;
select * from dbms_xplan.display_cursor(format=>'basic +rows');
select * from dba_tab_statistics where table_name='X$OBLNK$';
select /*+ dynamic_sampling(4) */ * from MYAPP_OWNER.PRODUCTS;
select * from dbms_xplan.display_cursor(format=>'basic +rows');
exec dbms_stats.gather_table_stats('MYAPP_OWNER','PRODUCTS');
select * from MYAPP_OWNER.PRODUCTS;
select * from dbms_xplan.display_cursor(format=>'basic +rows');
--- ## now that we have a seed we can create application PDBs
connect sys/oracle@//localhost/MYAPP_ROOT as sysdba
show con_name
show user
showappcon
create pluggable database MYAPP_CH admin user pdbadmin identified by oracle roles=(DBA) 
/
showappcon
--- # the PDB inherits from seed - no need to sync
alter pluggable database MYAPP_CH open;
connect sys/oracle@//localhost/MYAPP_CH as sysdba
show con_name
--- # all objects are there, ready to run app
select tablespace_name,file_name,file_id from dba_data_files;
select username,account_status,common,inherited,implicit from dba_users where oracle_maintained='N';
ddl MYAPP_OWNER.SALES
---
select * from MYAPP_OWNER.SALES;
---
ddl MYAPP_OWNER.PRODUCTS
---
select * from MYAPP_OWNER.PRODUCTS;
--- ## now creating local user to run the application
connect sys/oracle@//localhost/MYAPP_CH as sysdba
grant create session to MYAPP_CH_USER1 identified by oracle container=current;
info MYAPP_OWNER.NEW_SALE
grant execute on MYAPP_OWNER.NEW_SALE to MYAPP_CH_USER1;
grant select on MYAPP_OWNER.SALES_INFO to MYAPP_CH_USER1;
grant select any dictionary to MYAPP_CH_USER1;
--- ## the application is ready to execute
connect MYAPP_CH_USER1/oracle@//localhost/MYAPP_CH
show con_name
show user
alter session set current_schema=MYAPP_OWNER;
exec NEW_SALE(1,12);
exec NEW_SALE(3,24);
select * from SALES_INFO;
select * from SALES_INFO where quantity=0;
select * from dbms_xplan.display_cursor();
--- # we want to add an index, this is done in root
connect sys/oracle@//localhost/MYAPP_ROOT as sysdba
info+ MYAPP_OWNER.SALES
info+ MYAPP_OWNER.PRODUCTS
show con_name
show user
select * from dba_applications;
select * from dba_app_versions;
select * from dba_app_patches;
--- # this is a patch on application version 1.0
alter pluggable database application MYAPP begin patch 1337 minimum version '1.0' comment 'add index on SALES';
select * from dba_applications;
connect MYAPP_OWNER/oracle@//localhost/MYAPP_ROOT
--- # all patching operation must be done with same service/module
select sys_context('userenv','service_name'),sys_context('userenv','module') from dual;
create index SALES_QUANTITY on SALES(QUANTITY);
connect sys/oracle@//localhost/MYAPP_ROOT as sysdba
alter pluggable database application MYAPP end patch 1337;
select * from dba_applications;
select origin_con_id con_id,statement_id,app_name,app_status,patch_number,
 substr(replace(app_statement,chr(10),' '),1,50) app_statement
from dba_app_statements where app_name='MYAPP' order by statement_id
/
--- # list our application versions and patches
select * from dba_applications;
select * from dba_app_versions;
select * from dba_app_patches;
--- # we have another patch to apply to change date to timestamp
alter pluggable database application MYAPP begin patch 1664 minimum version '1.0' comment 'change sales date to timestamp';
connect MYAPP_OWNER/oracle@//localhost/MYAPP_ROOT
alter table SALES modify SALE_DATE timestamp;
connect sys/oracle@//localhost/MYAPP_ROOT as sysdba
alter pluggable database application MYAPP end patch 1664;
select * from dba_applications;
select origin_con_id con_id,statement_id,app_name,app_status,patch_number,
 substr(replace(app_statement,chr(10),' '),1,50) app_statement
from dba_app_statements where app_name='MYAPP' order by statement_id
/
--- # list our application versions and patches
select * from dba_applications;
select * from dba_app_versions;
select * from dba_app_patches;
--- # root is patched, ready to sync to PDBs
show con_name
info MYAPP_OWNER.SALES
desc MYAPP_OWNER.SALES
--- we have to sync the seed
connect sys/oracle@//localhost/MYAPP_ROOT$SEED as sysdba
info MYAPP_OWNER.SALES
alter pluggable database application MYAPP sync;
info MYAPP_OWNER.SALES
select * from dba_app_patches;
--- # PDB must also be synced
connect sys/oracle@//localhost/MYAPP_CH as sysdba
info MYAPP_OWNER.SALES
--- # we can apply patches individually
select * from dba_app_patches;
alter pluggable database application MYAPP sync to patch 1337;
select * from dba_app_patches;
alter pluggable database application MYAPP sync to patch 1664;
select * from dba_app_patches;
info+ MYAPP_OWNER.SALES
--- # run the application again
connect MYAPP_CH_USER1/oracle@//localhost/MYAPP_CH
show con_name
show user
alter session set current_schema=MYAPP_OWNER;
select * from SALES_INFO where quantity=0;
select * from dbms_xplan.display_cursor();

select app_name,patch_number,patch_comment,app_statement from dba_app_patches join dba_app_statements using (app_name,patch_number) where patch_status='INSTALLED' order by app_name,patch_min_version,patch_number,statement_id;
select p.* , (select app_statements from dba_app_statements s where a) from dba_app_patches p;
--- #!TODO: impdp sqlfile into app install
--- #!TODO: sync in proxy
--- ####################################################################
--- ### Lockdown profiles
--- ####################################################################
--- tmux select-pane -t :.0
--- # create a lockdown profile on CDB1 and set it in PDB1
connect /@CDB1 as sysdba
select * from dba_lockdown_profiles;
create lockdown profile DEMOLOCK;
alter session set container=PDB1;
show parameter lockdown
---
alter system set pdb_lockdown=DEMOLOCK scope=memory;
-- # create a PDB DBA user
grant DBA to PDBDBA identified by oracle container=current;
alter session set container=CDB$ROOT;
--- # connect as PDBDBA in another session and set a parameter
--- tmux resize-pane -Z -t :.0
--- tmux select-pane -t :.1
sqlcl PDBDBA/oracle@//localhost/PDB1
select listagg(role,',') within group(order by role) from session_roles;
alter system set optimizer_index_cost_adj=99;
--- # back to the CDB$ROOT session, add a rule to the profile
--- tmux select-pane -t :.0
alter lockdown profile DEMOLOCK disable statement = ('alter system');
select * from dba_lockdown_profiles;
--- # back to the PDB DBA session, try again to set a parameter
--- tmux select-pane -t :.1
alter system set optimizer_index_cost_adj=99;
--- # the error message is always 'insufficient privileges'
select * from dba_lockdown_profiles;
--- # only CDB$ROOT can explain what is locked down
quit
--- # cleanup
--- tmux resize-pane -Z -t :.0
connect sys/oracle@//localhost/CDB1 as sysdba
drop lockdown profile DEMOLOCK;
alter session set container=PDB1;
alter system set pdb_lockdown='';
alter system reset pdb_lockdown;
quit
--- ####################################################################
--- ### APPENDIX: Just in case you messed-up your database
--- ####################################################################
--- ## the CDB1 and CDB2 databases were created with:
grep ^CDB1: /etc/oratab || /u01/app/oracle/product/12.2.0/dbhome_1/bin/dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName CDB1 -sid CDB1 -initParams db_unique_name=CDB1,service_names=CDB1,dg_broker_start=false,shared_pool_size=600M,local_listener='(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))' -createAsContainerDatabase true -numberOfPdbs 1 -pdbName PDB0 -pdbAdminPassword oracle -sysPassword oracle -systemPassword oracle -emConfiguration NONE -datafileDestination /u01/oradata -recoveryAreaDestination /u01/fast_recovery_area -recoveryAreaSize 1024 -storageType FS -sampleSchema false -automaticMemoryManagement false -totalMemory 1024 -databaseType OLTP -enableArchive true
grep ^CDB2: /etc/oratab || /u01/app/oracle/product/12.2.0/dbhome_1/bin/dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName CDB2 -sid CDB2 -initParams db_unique_name=CDB2,service_names=CDB2,dg_broker_start=false,shared_pool_size=600M,local_listener='(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))' -createAsContainerDatabase true -numberOfPdbs 0 -pdbName PDB1 -pdbAdminPassword oracle -sysPassword oracle -systemPassword oracle -emConfiguration NONE -datafileDestination /u01/oradata -recoveryAreaDestination /u01/fast_recovery_area -recoveryAreaSize 1024 -storageType FS -sampleSchema false -automaticMemoryManagement false -totalMemory 1024 -databaseType OLTP -enableArchive true
--- # they can be deleted with
grep ^CDB1: /etc/oratab && /u01/app/oracle/product/12.2.0/dbhome_1/bin/dbca -silent -deleteDatabase -sourceDB CDB1 -forceArchiveLogDeletion -sysDBAPassword oracle -sysDBAUserName sys
grep ^CDB2: /etc/oratab && /u01/app/oracle/product/12.2.0/dbhome_1/bin/dbca -silent -deleteDatabase -sourceDB CDB2 -forceArchiveLogDeletion -sysDBAPassword oracle -sysDBAUserName sys
--- ####################################################################
--- ### APPENDIX: Apply January 2018 Release Update
--- ####################################################################
--- ## If you want to apply Jan 2018 RU (or Oct 2017 RUR)
# download from https://updates.oracle.com/download/27105253.html (or 27013510)
unzip p27105253_122010_Linux-x86-64.zip ; cd 27105253
dbshut $ORACLE_HOME
$ORACLE_HOME/OPatch/opatch apply -silent
dbstart $ORACLE_HOME
ORACLE_SID=CDB1 $ORACLE_HOME/OPatch/datapatch
ORACLE_SID=CDB2 sqlplus / as sysdba <<< startup
ORACLE_SID=CDB2 $ORACLE_HOME/OPatch/datapatch
ORACLE_SID=CDB2 sqlplus / as sysdba <<< shutdown
--- ### END until there ################################################
cd /u01/app/temp
# download
wget SSO_RESPONSE=`$WGET --user-agent="Mozilla/5.0" https://updates.oracle.com/Orion/Services/download 2>&1|grep Location`
SSO_TOKEN=`echo $SSO_RESPONSE| cut -d '=' -f 2|cut -d ' ' -f 1`
SSO_SERVER=`echo $SSO_RESPONSE| cut -d ' ' -f 2|cut -d 'p' -f 1,2`
SSO_AUTH_URL=sso/auth
AUTH_DATA="ssousername=$SSO_USERNAME&password=$SSO_PASSWORD&site2pstoretoken=$SSO_TOKEN"
$WGET --user-agent="Mozilla/5.0" --secure-protocol=auto --post-data $AUTH_DATA --save-cookies=$COOKIE_FILE --keep-session-cookies $SSO_SERVER$SSO_AUTH_URL -O sso.out >> $LOGFILE 2>&1
rm -f sso.out
$WGET  --user-agent="Mozilla/5.0"  --load-cookies=$COOKIE_FILE --save-cookies=$COOKIE_FILE --keep-session-cookies "https://updates.oracle.com/Orion/Services/download/p27105253_122010_Linux-x86-64.zip?aru=21862470&patch_file=p27105253_122010_Linux-x86-64.zip" -O $OUTPUT_DIR/p27105253_122010_Linux-x86-64.zip   >> $LOGFILE 2>&1 
# patch
srvctl config database -db cdb1
preupgrd
impdp remap schema C##
create pdb standbys
begin backup cannot close pdbs
triggers
--- ####################################################################
--- ### APPENDIX: If you are using GI (RAC, RON, or Oracle Restart)
--- ####################################################################








--- ####################################################################
--- ### Services in RAC
--- ####################################################################






--- ####################################################################
--- ### trigger
--- ####################################################################

--- # triggers

show parameter category
create or replace trigger TRIGGER_LOGON after logon on database begin 
 execute immediate q'[alter session set sqltune_category='after_logon_in_cdb$root']';
end;
/
connect system/oracle@//localhost/pdb1 
show parameter category
create or replace trigger TRIGGER_LOGON after logon on database begin 
 execute immediate q'[alter session set sqltune_category='after_logon_in_pdb1']';
end;
/
connect sys/oracle@//localhost/cdb1 as sysdba
show parameter category
connect sys/oracle@//localhost/pdb1 as sysdba
show parameter category
alter session set container=CDB$ROOT;
show parameter category
create or replace trigger TRIGGER_CONTAINER after set container on database begin 
 execute immediate q'[alter session set sqltune_category='after_set_container_in_cdb$root']';
end;
/
alter session set container=PDB1;
create or replace trigger TRIGGER_CONTAINER_AFT after set container on database begin 
 execute immediate q'[alter session set sqltune_category='after_set_container_in_pdb1']';
end;
/
alter session set container=CDB$ROOT;
show parameter category
alter session set container=PDB1;
show parameter category












end




select plan_table_output from v$sql , dbms_xplan.display_cursor(sql_id,child_number)
where sql_text like 'select /*+ first_rows(3) */ * from SALES_INFO order by quantity desc nulls last fetch first 3 rows only'
/
---








connect sys/oracle@//localhost/MYAPP_ROOT as sysdba
show con_name
show user
select * from dba_applications;
--- # this is a patch on application version 1.0





--- ##### cleanup application container #####
connect sys/oracle@//localhost/CDB1 as sysdba
exec declare j number; begin dbms_job.submit(j,'begin sys.dbms_feature_usage_internal.exec_db_usage_sampling(sysdate); commit; end;'); commit; end;
showappcon
select name feature_name,detected_usages,aux_count from dba_feature_usage_statistics where name like '%Pluggable%' or name like '%Multitenant%';
select * from dba_applications;
alter pluggable database MYAPP_CH close immediate;
drop pluggable database MYAPP_CH including datafiles;
alter pluggable database MYAPP_ROOT$SEED close immediate;
drop pluggable database MYAPP_ROOT$SEED including datafiles;
alter pluggable database MYAPP_ROOT close immediate;
drop pluggable database MYAPP_ROOT including datafiles;
alter system set db_create_file_dest='';
alter system reset db_create_file_dest;
showappcon
select * from dba_applications;


--- tmux pipe-pane -o "cat >> /tmp/tmux-pipe-pane1.log" 
 tmux set-hook -g alert-silence "run 'echo SILENCE >> /tmp/tmux-activity.txt'"
 tmux set-hook -g alert-activity "run 'echo ACTIVITY >> /tmp/tmux-activity.txt'"
 tmux set monitor-activity on
cat /tmp/tmux-activity.txt

ls
date
date
date
sleep 1
date
date
sleep 1
date
ls
date
cat /tmp/runFromVim.log





--- # Recommendation: always create and use a user created service for the application
--- ## Cleanup: removing the service
exec dbms_service.stop_service(service_name=>'APP_PDB1');
select name,network_name,creation_date,con_id from v$active_services;
exec dbms_service.delete_service(service_name=>'APP_PDB1');
select name,network_name,creation_date,con_id from v$active_services;
host lsnrctl status LISTENER_PDB1





rman target /@CDB2
repair pluggable database PDB9 from service 'CDB1';
run {
set newname for datafile '/u01/app/oracle/product/12.2.0/dbhome_1/dbs/UNNAMED00067' to '/u01/oradata/CDB2/PDB9/system01.dbf';
set newname for datafile '/u01/app/oracle/product/12.2.0/dbhome_1/dbs/UNNAMED00068' to '/u01/oradata/CDB2/PDB9/sysaux01.dbf';
set newname for datafile '/u01/app/oracle/product/12.2.0/dbhome_1/dbs/UNNAMED00069' to '/u01/oradata/CDB2/PDB9/undotbs.dbf';
restore pluggable database PDB9 from service 'CDB1';
}



--- # services
ssh oracle@192.168.78.106
. oraenv <<<+ASM
crsctl start has
acfsutil info fs
sudo /u01/app/12.2/grid/bin/acfsload start
/u01/app/12.2/grid/bin/asmcmd volenable --all
sudo /bin/mount -t acfs /dev/asm/advm-27 /acfs
srvctl start database -d CDB2B
srvctl start database -d CDB2A
srvctl start database -d CDB1
. oraenv <<<+ASM
srvctl config database
srvctl status database -db CDB1
srvctl config service -db CDB1
srvctl status service -db CDB1
lsnrctl status
. oraenv <<<CDB1
sql / as sysdba
show pdbs
quit
srvctl add service -db CDB1 -pdb PDB1 -service my_app
srvctl start service -db CDB1 -service my_app
lsnrctl status "(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=VM106)(PORT=1522)))"
sql / as sysdba
show pdbs
quit
srvctl add service -h | grep -iE --color=auto -- '-pdb|plug.*base|^'
srvctl stop service -db CDB1 -service my_app
lsnrctl status "(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=VM106)(PORT=1522)))"
sql / as sysdba
show pdbs
quit

--- show pdbs in sqlplus vs sqlcl
--- start service at startup -> save state
--- recovery area 6GB scope=spfile
--- backup tranport unplug
--- scoot select on v$instance


select 'Container Database' hierarchy,0 con_id#,name,'' status,'' applications,'' refresh_mode,dbid,'' foreign_dbid,'' foreign_con_id from v$database
union all
select hierarchy,con_id#,name,status,applications,refresh_mode,dbid,foreign_dbid,foreign_con_id from (
select
lpad(' ',level)||case 
when bitand(c.flags, 524288)=524288 then 'Proxy PDB'
when bitand(c.flags, 65536)=65536 then 'Application Root'
when bitand(c.flags, 131072)=131072 then 'Application Seed'
when bitand(c.flags, 2097152)=2097152 then 'Application Root Clone'
when fed_root_con_id# is not null then 'Application Container'
when con_id#=1 then 'Root'
when con_id#=2 then 'Seed'
else 'Pluggable database'
end hierarchy,
con_id#,o.name,
decode(c.status, 0, 'UNUSABLE', 1, 'NEW', 2, 'NORMAL', 3, 'UNPLUGGED',5, 'RELOCATING', 6, 'REFRESHING', 7, 'RELOCATED', 'UNDEFINED') status,
(select listagg(app_name||' '||app_version)within group(order by app_id) from cdb_applications a where a.con_id=con_id# and app_implicit='N') applications,
decode(bitand(c.flags, 134217728 + 268435456),134217728, 'MANUAL', 268435456, 'AUTO', 'NONE') refresh_mode,
c.dbid,
nvl((select max(name) from containers(v$database) cd where cd.dbid=f_cdb_dbid having count(distinct name)=1),f_cdb_dbid) foreign_dbid,
decode(f_cdb_dbid,(select dbid from v$database),(select name from v$pdbs cd where cd.con_id=f_con_id#),nvl((select max(name) from containers(v$pdbs) cd where cd.con_id=f_con_id# having count(distinct name)=1),c.f_con_id#)) foreign_con_id
from container$ c join obj$ o using(obj#)
connect by (level<=2 and con_id#>1 and fed_root_con_id# is null ) or (prior con_id#=c.fed_root_con_id#)
start with con_id#=1
order siblings by create_scnwrp,create_scnbas
) 
;
