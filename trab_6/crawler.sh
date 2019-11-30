#!/bin/bash
set -x
declare -a price
i=0
time=$(date +%M)

while true; do
    initial_time=$(date +%H:%M)
    while [[ "${time}" -eq $(date +%M) ]]; do
        price[i]+=$( curl -Ss  https://br.advfn.com/bolsa-de-valores/bmf/WINZ19/cotacao | grep quoteElementPiece19 | awk '{print $NF}' | sed 's/[Aa-zZ>"=&;.,</]//g' | sed 's/.\{2\}$//' ) 
        max_price=${price[$i]}
        min_price=${price[$i]}

        if (( "${max_price}" < "${price[$i]}" )); then
            max_price="${price[$i]}"
        fi

        if (( "${min_price}" > "${price[$i]}" )); then
            min_price="${price[$i]}"
        fi

        ((i++))    
    done;
    
    first_price=${price[0]}
    last_price=${price[-1]}

    echo -n "${initial_time},${first_price},${max_price},${min_price},${last_price}," >> data


done
