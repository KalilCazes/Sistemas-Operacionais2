#!/bin/bash

re='^[+-]?[0-9]+([.][0-9]+)?$'
if ! [[ $1 =~ $re ]] ; then
    echo -e "\nEsse script deve receber um número como parâmetro.\n"; exit 1
fi

n=$1
result=""
while [ "$n" != -1 ]; do
    result="${result} ${n}"
    n=$(($n-1))
done

echo $result