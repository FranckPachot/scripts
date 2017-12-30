/*
 To be run on each RAC instance
*/
DECLARE
    instno NUMBER;
    snapjob VARCHAR2(30);
    purgejob VARCHAR2(30);
BEGIN
    select instance_number into instno from v$instance;
    snapjob  := 'PERFSTAT.STATSPACK_SNAP_' || instno;
    purgejob := 'PERFSTAT.STATSPACK_PURGE_' || instno;
 
    DBMS_SCHEDULER.CREATE_JOB (
       job_name => snapjob,
       job_type => 'PLSQL_BLOCK',
       job_action => 'statspack.snap;',
       number_of_arguments => 0,
       start_date => systimestamp,
       repeat_interval => 'FREQ=HOURLY;BYTIME=0000;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN',
       end_date => NULL,
       enabled => TRUE,
       auto_drop => FALSE,
       comments => 'Take hourly Statspack snapshot');
 
    DBMS_SCHEDULER.CREATE_JOB (
       job_name => purgejob,
       job_type => 'PLSQL_BLOCK',
       job_action => 'statspack.purge(i_num_days=>31,i_extended_purge=>true);',
       number_of_arguments => 0,
       start_date => systimestamp,
       repeat_interval => 'FREQ=WEEKLY;BYTIME=120000;BYDAY=SUN',
       end_date => NULL,
       enabled => TRUE,
       auto_drop => FALSE,
       comments => 'Weekly purge Statspack snapshot');
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => snapjob, attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF );
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => snapjob, attribute => 'INSTANCE_ID', value=>instno);
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => snapjob, attribute => 'INSTANCE_STICKINESS', value=>TRUE);
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => purgejob, attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF );
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => purgejob, attribute => 'INSTANCE_ID', value=>instno);
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => purgejob, attribute => 'INSTANCE_STICKINESS', value=>TRUE);
END;
/
