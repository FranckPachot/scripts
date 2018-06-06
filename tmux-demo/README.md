## Install latest tmux on RedHat:

 sudo yum -y install tmux git ncurses-devel

 git clone https://github.com/libevent/libevent.git /tmp/libevent
 cd /tmp/libevent && sh autogen.sh && ./configure CFLAGS=-std=gnu99 && make && sudo make install
 git clone https://github.com/tmux/tmux.git /tmp/tmux
 cd /tmp/tmux && sh autogen.sh && ./configure && make && sudo make install

##

run the following in all windows to set the LD_LIBRARY_PATH and PATH:
 . demoenv.sh

run the 'demo' alias to open tmux session or attach to the existing one

open your testme.bash with 'vi', read an hit 'Page Down' to see what happens
