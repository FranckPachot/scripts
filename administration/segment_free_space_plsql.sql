-- dbauser@DB >@freespace
-- >      32,619 MB free of      117,934 MB |##############______| in   72% used, TABLE "MYUSER"."TABLEA"
-- >      23,137 MB free of       68,342 MB |#############_______| in   66% used, TABLE "MYUSER"."TABLEB"
-- >      13,494 MB free of       46,210 MB |##############______| in   71% used, TABLE "MYUSER"."TABLEC"
-- >       9,567 MB free of       29,087 MB |#############_______| in   67% used, TABLE "MYUSER"."TABLED"
-- >       5,692 MB free of       19,460 MB |##############______| in   71% used, TABLE "MYUSER"."TABLEE" partition "TABLEE_1"
-- >       4,834 MB free of       16,501 MB |##############______| in   71% used, TABLE "MYUSER"."TABLEF"
-- >       2,930 MB free of       11,899 MB |###############_____| in   75% used, TABLE "MYUSER"."TABLEG"
-- >       2,747 MB free of        9,180 MB |##############______| in   70% used, TABLE "MYUSER"."TABLEH"
-- >       2,779 MB free of        3,713 MB |#####_______________| in   25% used, TABLE "MYUSER"."TABLEI"
-- >       1,175 MB free of        3,609 MB |#############_______| in   67% used, TABLE "MYUSER"."TABLEJ"
-- >         759 MB free of        3,447 MB |################____| in   78% used, TABLE "MYUSER"."TABLEK"
-- >       1,958 MB free of        3,265 MB |########____________| in   40% used, TABLE "MYUSER"."TABLEL"

set serveroutput on
declare
  unf number; unfb number; fs1 number; fs1b number; fs2 number; fs2b number; fs3 number; fs3b number; fs4 number; fs4b number; full number; fullb number;
  free_space_bytes number;
  segment_bytes number;
  used_space_ratio number;
  graph varchar2(22);
begin
  for i in (select * from (select * from dba_segments where segment_subtype='ASSM' and segment_type in (
    'TABLE','TABLE PARTITION','TABLE SUBPARTITION','CLUSTER','LOB','LOB PARTITION','LOB SUBPARTITION'
  ) order by bytes desc) where 100>=rownum)
  loop
  begin
  dbms_space.space_usage(i.owner,i.segment_name,i.segment_type,unf,unfb,fs1,fs1b,fs2,fs2b,fs3,fs3b,fs4,fs4b,full,fullb,partition_name=>i.partition_name);
  free_space_bytes := unfb+fs1b+fs2b*0.25+fs3b*0.5+fs4b*0.75;
  segment_bytes:= i.bytes;
  used_space_ratio := 1-(nullif(free_space_bytes,0)/nullif(segment_bytes,0));
  graph:= rpad(rpad('|',1+(nvl(used_space_ratio,1)*20),'#'),21,'_')||'|';
  dbms_output.put_line('>'||to_char((free_space_bytes)/1024/1024,'999G999G999')||' MB free of '
  ||to_char(round(segment_bytes/1024/1024),'999G999G999')||' MB '
  ||graph||' in '
  ||to_char(round(100*nvl(used_space_ratio,1)),'999')||'% used, '
  ||i.segment_type||' "'||i.owner||'"."'||i.segment_name||'"'
  ||case when i.partition_name is null then '' else ' partition "'||i.partition_name||'"' end);
  exception
    when others then dbms_output.put_line('>>>> ERROR: '||i.segment_type||' "'||i.owner||'"."'||i.segment_name||'" partition "'||i.partition_name||'": '||sqlerrm);
  end;
end loop;
end;
/
