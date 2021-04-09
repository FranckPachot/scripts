/*
 To be run on each RAC instance as PERFSTAT
*/
DECLARE
    instno NUMBER;
    snapjob VARCHAR2(128);
    lightjob VARCHAR2(128);
    purgejob VARCHAR2(128);
BEGIN
    select instance_number into instno from v$instance;
    snapjob  := 'PERFSTAT.STATSPACK_SNAP_' || instno;
    lightjob  := 'PERFSTAT.STATSPACK_ZERO_' || instno;
    purgejob := 'PERFSTAT.STATSPACK_PURGE_' || instno;
 
    DBMS_SCHEDULER.CREATE_JOB (
       job_name => snapjob,
       job_type => 'PLSQL_BLOCK',
       job_action => 'statspack.snap;',
       number_of_arguments => 0,
       start_date => systimestamp,
       repeat_interval => 'FREQ=HOURLY;BYTIME=000000;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN',
       end_date => NULL,
       enabled => TRUE,
       auto_drop => FALSE,
       comments => 'Take hourly Statspack snapshot');
       
    DBMS_SCHEDULER.CREATE_JOB (
       job_name => lightjob,
       job_type => 'PLSQL_BLOCK',
       job_action => 'statspack.snap(i_snap_level=>0);',
       number_of_arguments => 0,
       start_date => systimestamp,
       repeat_interval => 'FREQ=HOURLY; BYMINUTE=5,10,15,20,25,30,35,40,45,50,55',
       end_date => NULL,
       enabled => TRUE,
       auto_drop => FALSE,
       comments => 'Take frequent Statspack snapshot level 0');
       
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
    
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => lightjob, attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF );
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => lightjob, attribute => 'INSTANCE_ID', value=>instno);
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => lightjob, attribute => 'INSTANCE_STICKINESS', value=>TRUE);
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => purgejob, attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF );
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => purgejob, attribute => 'INSTANCE_ID', value=>instno);
    DBMS_SCHEDULER.SET_ATTRIBUTE( name => purgejob, attribute => 'INSTANCE_STICKINESS', value=>TRUE);
END;
/
select job_name, state, enabled, next_run_date, instance_stickiness, instance_id from dba_scheduler_jobs where owner='PERFSTAT';
