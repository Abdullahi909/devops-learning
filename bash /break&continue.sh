#!/bin/bash 


for ((i=1; i<=5; i++))

do 

    if [ $i -eq 3 ]

    then 

        continue

    #break 
    
    fi 


echo "count: $i"


done 



car=1

while true 

do 

echo "cars: $car"
((car++))
 if [ $car -eq 5 ]
    then 
     break
   fi  

done 




car=1

while [ $car -le 5 ]

do 

if [ $car -eq 3 ]
then 
    ((car++))
    continue 
fi 
echo "amount of cars: $car"
((car++))

done 





