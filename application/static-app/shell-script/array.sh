#!/bin/bash

# Declare an associative array
declare -A myarray

# Define key-value pairs
myarray=(["name"]="zoya" ["age"]="29")

# Access and print values
echo "My name is ${myarray["name"]}"
