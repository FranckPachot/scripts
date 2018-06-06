# Semi-automatic demos ussing TMUX and VIM

## Install latest tmux on RedHat:

 sudo yum -y install tmux git ncurses-devel

 git clone https://github.com/libevent/libevent.git /tmp/libevent
 cd /tmp/libevent && sh autogen.sh && ./configure CFLAGS=-std=gnu99 && make && sudo make install
 git clone https://github.com/tmux/tmux.git /tmp/tmux
 cd /tmp/tmux && sh autogen.sh && ./configure && make && sudo make install
 run the 'demo' alias to open tmux session or attach to the existing one

## Run and play

From the terminal windows where you want to see the output of the demo:
```
tmux new-session -A -s demo
```
so you can run one on your laptop in small font and one larger on the screen

From another terminal window, open your script file with 'vi', for example testme.bash, read an hit 'Page Down' to see what happens
