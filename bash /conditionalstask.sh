#!/bin/bash 

grade=50

if [ "$grade" -ge 40 ]; then
echo "you passed"
    if [ "$grade" -ge 71 ]; then 
    echo "You got a first"
fi 
else echo "You failed"
fi 
