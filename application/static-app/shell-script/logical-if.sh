#!/bin/bash
echo "whats your age ? "
read age
echo "your country name ?"
read country

#if -else -multiple condition(elif)

if [[ $age -ge 18 ]]
 then 
      echo "you can vote"
 elif [[ $country == "india" ]]
  then 
     echo "you can vote in india"
 else 
      echo "you cant vote"
fi