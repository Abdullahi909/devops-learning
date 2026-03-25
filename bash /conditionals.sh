#!/bin/bash 


#Regular IF satement 
num1=29

if [ $num1 -lt 30 ]; then
echo "You failed"
fi




#with the ||= OR 
num2=65

if [ $num2 -ge 90 ] || [ $num2 -ge 60 ]; then 
echo "WE are winning"
fi 



#with the &&= AND 
num=55

if [ $num -lt 90 ] && [ $num -ge 50 ];then
echo "Well done"
fi 



#with == string comparison 
name=Abdullahi

if [ $name == Abdullahi ]; then 
echo "correct name"
fi 



# with the != not equal string comparison 

name=Abdullahi 

if [ $name != Ali ]; then 
echo "Wrong name"
fi




#with the 

name=Mohamed

if [ $name != ali ] && [ $name != ahmed ]; then 
echo "Not mohamed"
fi

