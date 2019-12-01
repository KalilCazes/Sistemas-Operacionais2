#!/bin/bash
#set -x

> data

while true; do

    current_time=$(date +%H:%M)

    max_price=0
    min_price=10000000

    prices=()
    i=0
    while [[ "${current_time}" == "$(date +%H:%M)" ]]; do

        prices+=($( curl -Ss  https://br.advfn.com/bolsa-de-valores/bmf/WINZ19/cotacao | grep quoteElementPiece19 | awk '{print $NF}' | sed 's/[Aa-zZ>"=&;.,</]//g' | sed 's/.\{2\}$//' )) 
        

        if (( max_price < prices[i] )); then
            max_price="${prices[$i]}"
        fi

        if (( min_price > prices[i] )); then
            min_price="${prices[$i]}"
        fi

        i=$((i+1))    
    done;
    
    first_price=${prices[0]}
    last_price=${prices[-1]}

    echo -n "${current_time},${first_price},${max_price},${min_price},${last_price}," >> data


done
