#!/bin/bash 

file_count(){

local dir=$1
local file

file=$(ls $dir | wc -l)

echo "number of files in $dir $file"




}

file_count "./"





search_file(){

local search_term="$1"
grep -n "$search_term" test-file.txt | awk '{ print $1 }' 




}

search_file "line"







#count_sh_files(){

#local file_count=$1
#local script_number

#script_number=$(ls $file_count | grep "\.sh$" | wc -l)


#echo "You have $script_number bash scripts"

#}


#count_sh_files "./"



#extract_names(){

#local name=$1

#grep "$name" names.txt | awk '{ print $2 }'     


#}

#extract_names "Name"


#analse_log(){

#local search=$1

#messages=$(grep $search app.log | wc -l)

#echo "Occurrences:$messages"


#line_numbers=$(grep -n $search app.log | awk -F: '{ print $1 }' )

#echo line numbers: $line_numbers

#}

#analse_log "SUCCESS"






