#!/bin/bash 


file_write(){

local file_path=$1
local data=$2

echo "$data" >> "$file_path" 



}

file_write "read.txt" "Hello Abdullahi"