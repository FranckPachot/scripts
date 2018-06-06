export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PATH=$PATH:/usr/local/bin
alias demo='LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/tmux new-session -A -s demo'
