delete from STATS$IDLE_EVENT;
insert into STATS$IDLE_EVENT
select name from V$EVENT_NAME
where wait_class='Idle';
commit;
