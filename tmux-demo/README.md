# Semi-automatic demos using TMUX and VIM

When I first used this technique I've written the following blog post:
https://blog.dbi-services.com/using-tmux-for-semi-interactive-demos/

Since then, my scripts have evolved and here are the latest ones that can be downloaded to the demo environment (very usefull if it is an ephemeral cloud service).

## Install latest tmux and vim on RedHat 
It is good to have recent version. I've used my scripts with VIM 8.0 and TMUX 2.6

```
sudo bash <<odus
 yum -y update
 yum -y install tmux git svn ncurses-devel automake libtool gdb gcc
 rm -rf /tmp/libevent /tmp/tmux /tmp/vim
 git clone https://github.com/libevent/libevent.git /tmp/libevent
 cd /tmp/libevent && sh autogen.sh && ./configure CFLAGS=-std=gnu99 && make && sudo make install && cd -
 rm -rf /tmp/libevent
 git clone https://github.com/tmux/tmux.git /tmp/tmux
 cd /tmp/tmux && sh autogen.sh && ./configure && make && sudo make install  && cd -
 rm -rf /tmp/tmux
 git clone https://github.com/vim/vim.git /tmp/vim
 cd /tmp/vim/src && make && sudo make install
 rm -rf /tmp/vim
odus
```
## Download this folder and install the files
** be careful, .bashrc .inputrc .tmux.conf .vimrc will be overwritten. You may customize them **

```
cd && rm -rf tmux-demo && LC_ALL=en_US.utf8 svn export https://github.com/FranckPachot/scripts/trunk/tmux-demo
# backup the files that will be overwritten
[ -f tmux-demo-oldfiles.tar ] || tar -cvf tmux-demo-oldfiles.tar $(ls .bashrc .inputrc .tmux.conf .vimrc)
# copy the files (enter y to acknowlege overwriting)
cp -ip ~/tmux-demo/* ~/tmux-demo/.* ~ ; . .bashrc
```

## Run and play

From the terminal windows where you want to see the output of the demo, run `demo` which is is an alias for `LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/tmux new-session -A -s demo`
You can run it from multiple terminals, for example one with larger fonts to display on the beamer and one with small fonts on your laptop. What you type or see in one is identical on the other, thanks to tmux attached sessions.

From another terminal window, on your laptop screen only, open your script file with 'vim', and hit 'Page Down' to see what happens.
Example:
```
vim testme.bash
```
The following macros are defined in vi (see .vimrc):
 - PageDown runs the current line
 - F12 runs all from start to current line
 
Here 'run' roughly means:
 - run the commands for lines starting with `---`
 - send lines not starting with `---` (It is a bit more complex than that, see runFromVim.sh) 
 - Shift-F2 runs all selected lines

