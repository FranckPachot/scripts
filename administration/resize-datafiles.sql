with
 hwm as (
  -- get highest block id from each datafiles ( from x$ktfbue as we don't need all joins from dba_extents )
  select /*+ materialize */ ktfbuesegtsn ts#,ktfbuefno relative_fno,max(ktfbuebno+ktfbueblks-1) hwm_blocks
  from sys.x$ktfbue group by ktfbuefno,ktfbuesegtsn
 ),
 hwmts as (
  -- join ts# with tablespace_name
  select name tablespace_name,relative_fno,hwm_blocks,con_id
  from hwm join v$tablespace using(ts#)
  --where con_id=sys_context('userenv','con_id')
 ),
 hwmdf as (
  -- join with datafiles, put 5M minimum for datafiles with no extents
  select file_name,nvl(hwm_blocks*(bytes/blocks),5*1024*1024) hwm_bytes,bytes,autoextensible,maxbytes,con_id
  from hwmts right join cdb_data_files using(tablespace_name,relative_fno,con_id)
 )
select
 case when autoextensible='YES' and maxbytes>=bytes
 then -- we generate resize statements only if autoextensible can grow back to current size
  '/* CON_ID='||to_char(con_id,'9999')||' reclaim '||to_char(ceil((bytes-hwm_bytes)/1024/1024),999999)
   ||'M from '||to_char(ceil(bytes/1024/1024),999999)||'M */ '
   ||'alter database datafile '''||file_name||''' resize '||ceil(hwm_bytes/1024/1024)||'M;'
 else -- generate only a comment when autoextensible is off
  '/* CON_ID='||to_char(con_id,'9999')||' reclaim '||to_char(ceil((bytes-hwm_bytes)/1024/1024),999999)
   ||'M from '||to_char(ceil(bytes/1024/1024),999999)
   ||'M after setting autoextensible maxsize higher than current size for file '
   || file_name||' */'
 end SQL
from hwmdf
where
 bytes-hwm_bytes>1024*1024 -- resize only if at least 1MB can be reclaimed
union all
 select '/* CON_ID='||to_char(con_id,'9999')||'}                               */ alter session set container='||name||';' from v$containers
order by 1 desc
--con_id,bytes-hwm_bytes desc
/
