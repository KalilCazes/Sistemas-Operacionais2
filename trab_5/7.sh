#!/bin/bash

tabs 25
while read line; do
  echo "$( echo "$line" | tr ":" "\t" | awk '{ print $1 "\t " $5 }' )"
done </etc/passwd