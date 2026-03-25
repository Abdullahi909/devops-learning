#!/bin/bash 







greeting(){
local name 

if [ $# -eq 0 ]; then 
echo " What is your name"
read name
else 
name=$1
fi 

echo "Hello, $name"

}

greeting 


