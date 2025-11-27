#!/bin/bash

echo "choose an option"

echo "a = to see the date"

echo "b = to list the files in the current folder"

echo "c = to check the current location"

read option

case $option in
a)date;;
b)ls;;
c)
     echo "your current location is"
     pwd;;
*)echo "invalid option";;
esac