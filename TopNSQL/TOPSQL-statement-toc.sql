set linesize 2000
column sql_text noprint new_value sql_text 
set heading off markup html off
select distinct substr(sql_text,1,100) sql_text from dba_hist_sqltext where dbid=&1 and sql_id='&2';
prompt <tr><td align="right">&5.</td><td><A href="#&2./&3.">&2</A></td><td>&3</td><td align="right">&6</td><td align="right">&7</td><td align="right">&8</td><td align="right">&9</td><td>&sql_text</td></tr>
set heading on markup html on entmap on preformat off 
column sql_text clear