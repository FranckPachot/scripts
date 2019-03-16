# I use TITLE to show the end-time of the session in the Presenter window
TITLE="00:00"
SESSION="demo"
# The window names '-' 'DEMO' and 'Presenter' are used to minimize/maximize with the MaximizeDEMO MinimizeDEMO shortcuts
echo -en "\033]0;-\a"
# following is needed if tmux installed in /usr/local by compiling the source
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PATH=$PATH:/usr/local/bin
# -A means attached if the session already exists.
alias demo='if LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/tmux list-session ; then echo -en "\033]0;Presenter $TITLE\a"; else echo -en "\033]0;DEMO Screen\a"; fi; LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/tmux new-session -A -s $SESSION'
# following are some variables I use in my scripts (here set for Oracle DBaaS)
export HOST=localhost
export DBNAME=$ORACLE_SID
[ -n "$ORACLE_HOSTNAME" ] && export DOMAIN=.${ORACLE_HOSTNAME##*-}
export PASSWORD="Ach1z0#d"
# and a few shortcuts I like to have for my demos
alias arc='o=$ORACLE_SID ; rm -rf /u01/app/oracle/audit/CDB?/* ; date > /u01/app/oracle/diag/rdbms/cdb1/CDB1/trace/alert_CDB1.log ; for i in $(awk -F: "/^[a-zA-Z0-9]+:/{print \$1}" /etc/oratab | sort -u ) ; do . oraenv <<< $i ; rman target / <<< "delete noprompt archivelog all;" &  done >/dev/null ; wait ; o=$ORACLE_SID'
alias trc='cd $( dirname $(ls -t $ORACLE_BASE/diag/rdbms/*/$ORACLE_SID/trace/alert_$ORACLE_SID.log | head -1) )'
alias oratop='$ORACLE_HOME/suptools/oratop/oratop / as sysdba -f'
alias sqlcl='JAVA_HOME=$ORACLE_HOME/jdk SQLPATH=~/sql bash $ORACLE_HOME/sqldeveloper/sqlcl/bin/sql'
alias connect=sqlcl
alias sql=sqlcl
alias quit='echo -e "\n\n\n\n"'
alias vi=vim
shopt -s histappend
history -a
HISTCONTROL=ignoreboth
