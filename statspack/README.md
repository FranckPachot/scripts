Please refer to UKOUG Oracle Scene article: [Improving Statspack Experience ](http://viewer.zmags.com/publication/dd9ed62b#/dd9ed62b/36)

Here are the related scripts for Statspack installation:
 - 01-install.sql to create the tablespace and call spcreate
 - 02-schedule.sql to schedule snap and purge jobs
 - 03-idle-events.sql to fix issue described at https://blog.dbi-services.com/statspack-idle-events/
 - 04-modify-level.sql to collect execution plans and segment statistics
 
 Additional scripts:
 - 08-create-delta-views.sql to create views easy to query
 - 11-comment-with-load.sql to add load information to snapshots without comments
