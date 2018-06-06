---# lines starting with triple dash are executed as-is by the shell
---# As those ones are comments, there are no visible effects 
---#
---# however those starting with triple dash and double hash are displayed in tmux message bar:
--- ## Hello World is displayed in the message bar

---# a black line is send as 'Enter'. You need a comment (---#) to send nothing
---# and the reason is that we update the current line  in the tmux status bar
---#
---## lines starting with triple dash are executed as shell and can be tmux or other commands
---tmux clock-mode
---tmux split-window
---tmux select-pane -t :.1
echo "The lines not starting with triple dash are send with send-keys"
date \

# and this includes new lines as above
---tmux select-pane -t :.0
---sleep 3
---tmux select-pane -t :.1
exit

---#
---# you can type *** F12 *** here to run all down to the current line
