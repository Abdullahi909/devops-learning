#!/bin/bash


check(){

local file1=$1
local file2=$2

md5sum $file1
md5sum $file2

sha256sum $file1
sha256sum $file2






}

check "names.txt" "applog.txt"