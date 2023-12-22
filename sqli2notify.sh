#!/usr/bin/env bash
command="$(ps -f | grep $@ | grep sqlmap | ps ww -o cmd= -p $(cut -d' ' -f 2))"
date="$(date "+%d %b %Y %H:%M")"

text="<b>SQLi found !</b>%0A
<i>$date</i>%0A
<code>$command</code>"

echo text | notify