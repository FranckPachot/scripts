cat > /media/sf_share/DEMO/Multitenant/MT-Workshop.sql.html <<'EOF'
<h1>Oracle 12<i>c</i>R2 Multitenant Workshop</h1>
<p><i>
Download the VM from <a href=http://172.22.11.1/sources/VM122-Multitenant.ova>http://172.22.11.1/sources/VM122-Multitenant.ova</a>, connect as oracle, run deploy, and wait. Take snapshots at the begining of each chapter to be able to revert.
</i></p>
EOF
awk '
/### END until there ###/{
exit
}
/F12 until there/{
 F12="F12"
 next
}
F12=="" {
next
}
{
gsub(/>/,"\\&gt;")gsub(/</,"\\&lt;")
}
BEGIN{
h1=0
h2=0
#print "<style type=text/css> pre { width: 99%; max-height: 800px; color: #444; padding: 10px; background: #eee; border: 1px solid #ccc; border-radius: 5px; word-wrap: normal; overflow: auto; } </style>"
print "<style type=text/css> pre:not(:empty) { background: #eee; padding:10px; border: 1px solid #ccc; } h1 { border-bottom: 1px solid black} </style>"
 print "<pre>"
 F12=""
}
/^--- #!/{
 next
}
/^---$/{
 next
}
/^--- [^#]/{
 next
}
/^--- #####*$/{
 #print ""
 next
}
/^--- ### /{
 h1=h1+1
 h2=0
 sub(/--- ### /,"")
 print "</pre>"
 print "<a name=" h1 "><h1>Chapter " h1 ". " $0 "</h1>"
 print "<pre>"
 next
}
/^--- ## /{
 h2=h2+1
 sub(/--- ## /,"")
 print "</pre>"
 print "<a name=" h1 "." h2 "><h2>" h1 "." h2 ". " $0 "</h2>"
 print "<pre>"
 next
}
/^--- # /{
 sub(/--- # /,"")
 print "</pre>"
 print $0
 print "<pre>"
 next
}
/^#/{
 sub(/--- # /,"")
 print "<b>"
 print $0
 print "</b>"
 next
}
/^--/{
 sub(/--- # /,"")
 print "<b>"
 print $0
 print "</b>"
 next
}
END{
 print "<pre>"
}
{ 
print
}
' /media/sf_share/DEMO/Multitenant/MT-Workshop.sql > /tmp/MT-Workshop.sql.html
awk '
/<h1/{
h1=h1+1
h2=0
sub(/.*<h1>/,"")
sub(/[.] /,". <a href=#"h1">")
sub(/<.h1>.*$/,"</a><br/>")
print "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",$0
} ' /tmp/MT-Workshop.sql.html | tee -a /media/sf_share/DEMO/Multitenant/MT-Workshop.sql.html
cat /tmp/MT-Workshop.sql.html >> /media/sf_share/DEMO/Multitenant/MT-Workshop.sql.html
cygstart /media/sf_share/DEMO/Multitenant/MT-Workshop.sql.html
