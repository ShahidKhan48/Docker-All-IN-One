#!/bin/bash

# This is an associative array (key-value pair)

declare -A myarray

myarray=(["name"]="shahid" ["age"]="29"  ["city"]="bangalore")

echo "My name is ${myarray["name"]}" 