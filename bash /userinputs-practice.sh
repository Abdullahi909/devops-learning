#!/bin/bash 


age_cal(){

local year
local age

echo "What is your birth year?"
read year
age=$(( 2025 - year ))
echo "You are $age years old"





}


age_cal




