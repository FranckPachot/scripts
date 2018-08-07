with function freebytes(segment_owner varchar2, segment_name varchar2, segment_type varchar2,partition_name varchar2) return number as
 unf number; unfb number; fs1 number; fs1b number; fs2 number; fs2b number; fs3 number; fs3b number; fs4 number; fs4b number; full number; fullb number; 
begin
 dbms_space.space_usage(segment_owner,segment_name,segment_type,unf,unfb,fs1,fs1b,fs2,fs2b,fs3,fs3b,fs4,fs4b,full,fullb,partition_name=>partition_name);
 return unfb+fs1b+fs2b*0.25+fs3b*0.5+fs4b*0.75;
end;
select round(freebytes(owner,segment_name,segment_type,partition_name)/1024/1024/1024,3) free_GB,segment_type,owner,segment_name,partition_name
from dba_segments  where segment_subtype='ASSM' and segment_type in (
  'TABLE','TABLE PARTITION','TABLE SUBPARTITION','INDEX','INDEX PARTITION','INDEX SUBPARTITION','CLUSTER','LOB','LOB PARTITION','LOB SUBPARTITION'
) order by bytes desc fetch first 10 rows only
/
