awk '

BEGIN{
}

# empty line is send as "Enter"
/^$/{
 print "tmux send-keys C-M"
 next
}

# lines which starts with "tmux "are executed as-is. For backward compatibility with my old scripts
# now I start lines with "---" to run any command, including tmux ones.
/^tmux /{
 sub(/^.*@@@/,"")
 print
 next
}

# lines wich starts with "---" with nothing else is the correct way to send "Enter" without having a new line
/^---$/{
 print "tmux send-keys C-M"
 next
}

# lines starting with "--- ##" are comments displayed in the message bar (have only one # if you do not want them displayed)
/^--- ##* /{
 print "tmux display-message -- " q $0 q
}

# lines wich starts with "---" (except followed by ##) run the remaining as a shell command. Can by anything.
# note that followed by one # only they are comments as it runs a comment
/^---/{
 sub(/^.*---/,"")
 print
 next
}

# lines not starting with "tmux" or with "---" will be send with send-keys 
!/^---/{
 # the line will be send in quotes, so we have to replace quotes with: end quote, add double-quote within quote, start quote again
 gsub(q, q qq q qq q)
 # we display the command on the message line here it is before adding tmux send-keys in front
 message=$0
 # we add tmux send-keys in front
 $0="tmux send-keys -- " q $0 q " C-M"
 # in tmux ; is special when at the end so I backslash it there
 sub(";"q" C-M","\\;"q" C-M" )
 # this tmux send-key goes to output to be run by shell
 print
 # line number goes to stderr
 print "echo "NR":" $0 " >&2"
 # the message is displayed
 print "tmux display-message -- " q message q
 # when arg1 is not pageDown ( i.e when running several lines in batch) we wait if the cursor is at the end of the screen as it probably means that something is still running.
 if ( arg1 != "PageDown" ) {
  print "while { tmux run-shell "q"echo Cursor is at X=#{cursor_x}."q" & sleep 0.3 ; kill $! 2>/dev/null ; } | grep "q"X=0."q" >/dev/null ; do sleep 0.7 ; echo -n . ; done "
 }
 print "# arg1: " arg1
 next
}
' q="'" qq='"' arg1="$1" | tee /tmp/runFromVim.log | bash 

exit
