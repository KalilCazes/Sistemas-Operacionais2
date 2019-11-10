#!/bin/bash

re='^[+-]?[0-9]+([.][0-9]+)?$'
if ! [[ $1 =~ $re &&  $2 =~ $re ]] ; then
    echo -e "\nEsse script deve receber dois números como parâmetro.\n"; exit 1
fi

if [ "$1" -gt "$2" ]
then
    echo -e "\n$1 é maior que $2"
else
    if [ "$1" -lt "$2" ]
    then
        echo -e "\n$1 é menor que $2"
    else
        echo -e "\n$1 é igual a $2"
    fi
fi