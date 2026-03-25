#!/bin/bash 

for colors in red bule green 

do echo "color: $colors"

done 





weekdays=("Monday" "Tuesday" "wednesday")

for day in ${weekdays[@]}

do echo "Todays is: $day"

done 





for number in $(seq 10 1)

do echo "count down: $number"

done 




for ((w=1; w<=10; w++))

do echo "number: $w"

done 




tasks=("1[]gym" "2[]coding" "3[]netflix" "4[]shoping")

for things in ${tasks[@]}

do echo "weekend plan: $things"


done 














