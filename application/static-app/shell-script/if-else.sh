#!/bin/bash

echo "enter your marks"
read marks

# conditional statement type 1  (if)
if [[ $marks -gt 90 ]]
then
echo "pass"

elif [[ $marks -lt 90 ]]
then
echo "failed"

elif [[ $marks -eq 40]]
then
echo " just pass"
fi