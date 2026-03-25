#!/bin/bash 


for animals in cat dog bird 

do echo "animal: $animals"

done 




fruits=("Apple" "Orange" "Banana")

for food in "${fruits[@]}"

do echo "fruit: $food"
 
done 



for (( i=1; i<=5; i++ ))

do echo "number: $i"

done 


for number in $(seq 1 5)

do echo "sequence: $number"

done






