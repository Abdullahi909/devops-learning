#!/bin/bash


name=("sara" "ali" "omar")
index=0

while [ $index -lt ${#name[@]} ]

do echo "name:${name[$index]}"
   ((index++))

done 




count=1

while [ $count -le 10 ]

do echo "count:$count"
((count++))

done 



