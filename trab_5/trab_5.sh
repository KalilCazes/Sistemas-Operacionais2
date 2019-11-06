#!/bin/bash

w | awk '{print $1}'

df -h | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5  "\t" $6}'

date | awk '{ print $4 }'