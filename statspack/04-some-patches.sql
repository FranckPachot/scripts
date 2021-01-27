-- add a timestamp column to STATS$SQL_PLAN for use by dbms_xplan
alter table perfstat.stats$sql_plan add timestamp invisible as (cast(null as date));
