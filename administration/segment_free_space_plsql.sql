set serveroutput on
declare
 unf number; unfb number; fs1 number; fs1b number; fs2 number; fs2b number; fs3 number; fs3b number; fs4 number; fs4b number; full number; fullb number; 
begin
 for i in (select * from (select * from dba_segments where segment_subtype='ASSM' and segment_type in (
  'TABLE','TABLE PARTITION','TABLE SUBPARTITION','INDEX','INDEX PARTITION','INDEX SUBPARTITION','CLUSTER','LOB','LOB PARTITION','LOB SUBPARTITION'
 ) order by bytes desc) where 10&gt;=rownum)
 loop
  begin
   dbms_space.space_usage(i.owner,i.segment_name,i.segment_type,unf,unfb,fs1,fs1b,fs2,fs2b,fs3,fs3b,fs4,fs4b,full,fullb,partition_name=&gt;i.partition_name);
   dbms_output.put_line(to_char((unfb+fs1b+fs2b*0.25+fs3b*0.5+fs4b*0.75)/1024/1024/1024,'999G999D999')||' GB free in '||i.segment_type||' "'||i.owner||'"."'||i.segment_name||'" partition "'||i.partition_name||'"');
  exception
   when others then dbms_output.put_line(i.segment_type||' "'||i.owner||'"."'||i.segment_name||'" partition "'||i.partition_name||'": '||sqlerrm);
  end; 
 end loop;
end;
/
