#!/bin/bash

set -e

num1=10 
num2=5

if [ $num1 -eq 0 ] || [ $num2 -eq 0 ]; then
    echo "This opperation cant be done with zero"
    exit 1
fi 

results=$((num1 / num2))

echo "The answer is $results"



#file="/Users/Abdullahi/Desktop/Dev ops learning docs"

#if [ -d "$file" ]; then 
#echo "File exists"
#else echo "File does not exist"
#fi


#command -v git 2>/dev/null


#if [ $? -ne 0 ]; then 
#echo "git is not installed, please install git"
#exit 1
#else echo "git is installed"
#fi 