# following is needed if tmux installed in /usr/local by compiling the source
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PATH=$PATH:/usr/local/bin
# -A means attached if the session already exists.
alias demo='LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/tmux new-session -A -s demo'
# following are some variables I use in my scripts (here set for Oracle DBaaS)
export HOST=localhost
export DBNAME=$ORACLE_SID
export DOMAIN=.${ORACLE_HOSTNAME##*-}
export PASSWORD="Ach1z0#d"
# and a few shortcuts I like to have for my demos
alias arc='rm -rf /u01/app/oracle/audit/CDB?/* ; date > /u01/app/oracle/diag/rdbms/cdb1/CDB1/trace/alert_CDB1.log ; for i in $(awk -F: "/^[a-zA-Z0-9]+:/{print \$1}" /etc/oratab | sort -u ) ; do . oraenv <<< $i ; rman target / <<< "delete noprompt archivelog all;" &  done >/dev/null ; wait'
alias trc='cd $( dirname $(ls -t $ORACLE_BASE/diag/rdbms/*/$ORACLE_SID/trace/alert_$ORACLE_SID.log | head -1) )'
alias oratop='$ORACLE_HOME/suptools/oratop/oratop / as sysdba'
alias sqlcl='JAVA_HOME=$ORACLE_HOME/jdk SQLPATH=~/sql bash $ORACLE_HOME/sqldeveloper/sqlcl/bin/sql'
alias connect=sqlcl
alias sql=sqlcl
alias quit='echo -e "\n\n\n\n"'
