#!/bin/bash
SERVICE="GURU-CE"
result=`ps aux | grep "ruby /home/carloswherbet/Projects/guru_ce_bot/bin/main.rb" | wc -l`
echo $result
if [ $result -ge 2 ]
then
    echo "$SERVICE is running"
else
    echo "$SERVICE stopped"
    /home/carloswherbet/.rbenv/shims/ruby /home/carloswherbet/Projects/guru_ce_bot/bin/main.rb
fi