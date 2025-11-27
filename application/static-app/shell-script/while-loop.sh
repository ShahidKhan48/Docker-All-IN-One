#!/bin/bash


echo "this is while  loop"

count=0
number=10

while [[ $count -le $number ]]

do 
   echo "number are $count"
   let count++ 
done