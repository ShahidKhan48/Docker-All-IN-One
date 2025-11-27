#!/bin/bash


echo "this is until loop"

count=10
number=1

until [[ $count -lt $number ]]

do 
   echo "number are $count"
   let count--
   #count='expr $count -1'
done