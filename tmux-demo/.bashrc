# following is needed if tmux installed in /usr/local by compiling the source
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PATH=$PATH:/usr/local/bin
# -A means attached if the session already exists.
alias demo='LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/tmux new-session -A -s demo'
# following are some variables I use in my scripts
HOST=localhost
DBNAME=$ORACLE_SID
