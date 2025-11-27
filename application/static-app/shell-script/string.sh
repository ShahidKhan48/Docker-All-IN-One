#!/bin/bash

#this is string varialble
myvar="sonam darling kaisi ho janeman i miss u a lot"
echo my string is :     "$myvar"

#total length of string
echo "Length: ${#myvar}"
#upper case 
echo "  $(echo "$myvar" | tr '[:lower:]' '[:upper:]')"

#lower case
echo " $(echo "$myvar" | tr '[:upper:]' '[:lower:]')"


#substring extraction
echo "Substring: ${myvar:6:11}"

