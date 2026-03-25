#!/bin/bash 

#cd /Users/Abdullahi/desktop

#mkdir Arena 

#cd Arena 


#touch mage.txt
#touch warrior.txt 
#touch archer.txt 

#ls 


#num=1

#while [ $num -le 10 ]
#do
#echo "$num"
#((num++))
#done 



#cd arena

#if [ -f Hero.txt  ]; then

#echo "Hero Found"

#else 

#echo "Hero Missing"

#fi 






#cp arena/*.txt backup 

#mkdir Battlefield 

#cd Battlefield 

#touch knight.txt 
#touch sorcerer.txt
#touch rogue.txt 
 
#mkdir Archive 

#if [ -f knight.txt ]; then 

#mv knight.txt Archive 
#fi 

#ls 

#cd Archive 

#ls



argument(){

local filename=$1
local file 

if [ -e $filename ]; then 

echo "File has been provided"

else echo "File has not been provided"

exit 

fi

file=$(wc -l $filename)

echo "the number of lines in $filename:$file"

}


argument ""

