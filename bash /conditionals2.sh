#!/bin/bash

age=15

if [ $age -ge 18 ]; then 
echo "You are an adult"
else echo "You are a kid"
fi

age1=15

if [ "$age1" -ge 21 ]; then 
    echo "You are a adult"
elif [ "$age1" -le 19 ] && [ "$age1" -ge 13  ]; then  
    echo "You are a teen"
else
 echo "your a kid"
fi 



