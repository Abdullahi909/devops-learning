#!/bin/bash 


#name(){

#local name 
#name=$1

#echo "What is your name?"

#read name 

#echo "Hello, $name "



#}

#name 


#age_days(){

#local age 

#days=365 

#echo "How old are you"
#read age 

#result=$(( age * days ))

#echo "your age in days is $result "



#}

#age_days 





#vote_check(){

#local age 

#echo "How old are you "
#read age 

#if [ $age -ge 18 ]; then
#echo "You are eligible to vote"
#elif [ $age -lt 18 ]; then 
#echo "You are uneligible to vote"
#fi



#}

#vote_check







#cal_1(){

#local num1 
#local num2 
#local opperation

#echo "Give me a number"
#read num1 

#echo "Give me another number"
#read num2 

#echo "pick and opperation: add, subtract, multiply or divide"
#read opperation 

#if [ $opperation == add ]; then 
#results=$(( num1 + num2 ))
#elif [ $opperation == subtract ]; then 
#results=$(( num1 - num2 ))
#elif [ $opperation == multiply ]; then 
#results=$(( num1 * num2 ))
#elif [ $opperation == divide ]; then 
#results=$(( num1 / num2 ))
#else 
#echo "please enter a valid opperation"
#fi 

#echo " Your answer is $results"


#}

#cal_1





#grade_cal(){

#local name 

#local grade 

#echo "what is your name"
##read name 
#echo "what is your test score"
#read grade 

#if [ $grade -ge 90 ]; then 
#echo "You got a grade A" 
#elif [ $grade -le 89 ] && [ $grade -ge 80 ]; then 
#echo "You got a grade B"
#elif [ $grade -le 79 ] && [ $grade -ge 70 ]; then 
#echo "You got a grade C"
#elif [ $grade -le 69 ] && [ $grade -ge 60 ]; then 
#echo "You got a F"
#else echo "You failed"
#fi 

#echo " $name you got a $grade "

#}

#grade_cal 



#num=1 

#while [ $num -le 5 ]
#do echo "number: $num " 
#(( num ++ ))
#done 




#start=10 

#while [ $start -ge 1 ]
#do echo "number: $start"
#((start -- ))

#done 




#guess_game(){

#local number 

#secret=90 


#echo "Guess the number"
#read number

#while [ $number -ne $secret ]
#do echo "wrong number, try again"
#read number 
#done 

#echo "You guessed correct!!"

#}


#guess_game 




password_st(){

local pass
password=bash123
attempts=1

echo "enter password"
read pass

while [ $attempts -le 3 ]
do 

if [ $pass == $password ]; then 
echo "Access granted"
break
elif [ $pass != $password ]; then 
echo "Acess denied attempt:$attempts/3"
((attempts++))

if [ $attempts -gt 3 ]; then 
echo "Account locked, too many attempts"
break 
fi 
echo "Enter password"
read pass 
 
fi




done 




}

password_st 