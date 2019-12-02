#!/bin/bash

tput reset
tput civis

stick="│"
candle="█"

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
no_color='\033[0m'

end_loop=0
while [ "$end_loop" -ne 1 ]; do

    date=()
    close=()
    open=()
    high=()
    low=()

    i=0
    raw=$(cat "${1}")
    export IFS=","
    for r in $raw; do

        if ((i==0)); then
            date+=("$r")
        elif ((i==1)); then
            open+=($((r*10)))
        elif ((i==2)); then
            high+=($((r*10)))
        elif ((i==3)); then
            low+=($((r*10)))
        elif (( i==4 )); then
            close+=($((r*10)))
        fi
        i=$(((i+1)%5))
    done

    max_value=0
    min_value=10000000

    screen_h=$(( $(tput lines)-1 ))
    screen_w=$(( $(tput cols)/2 ))

    for (( t=0; t<${#close[@]}; t++ )); do

        if (( t >= ${#close[@]}-screen_w ));then
            if (( low[t] < min_value)); then
                min_value=$((low[t]))
            fi

            if (( high[t] > max_value)); then
                max_value=$((high[t]))
            fi  
        fi

    done

    min_value=$(( min_value - (max_value-min_value)*40/100 ))
    max_value=$(( max_value + (max_value-min_value)*40/100 ))

    date_size=5

    plot_size_y=$((screen_h-date_size))

    candle_size=$(( (max_value-min_value)/(plot_size_y) ))

    if ((candle_size <= 0)); then
        candle_size=1
    fi

    prices=()
    prices_size=0
    for (( i=0; i<screen_h-date_size; i++ )); do
        if (( i%2==0 )); then
            prices[$i]=$(( min_value + i*candle_size ))
            temp_size=${#prices[$i]}
            prices[$i]="R$ ${prices[$i]:0:$((temp_size-3))},${prices[$i]:$((temp_size-3)):2}"
            prices_size=${#prices[$i]}
        else
            prices[$i]=""
        fi
    done

    plot_size_x=$((screen_w-prices_size))
    
    declare -A screen

    for (( i=0; i<plot_size_y; i++ )); do
        for (( j=0; j<plot_size_x; j++ )); do
            screen[$i,$j]=" "
        done
    done

    dates=()

    for (( t=${#close[@]}; t>=0; t-- ));do
        if (( ${#close[@]} - t < plot_size_x )); then
            for (( i=0; i<plot_size_y; i++ )); do

                c=$(( (${close[$t]}-min_value)/candle_size ))
                o=$(( (${open[$t]}-min_value)/candle_size ))
                h=$(( (${high[$t]}-min_value)/candle_size ))
                l=$(( (${low[$t]}-min_value)/candle_size ))

                h_candle=0
                l_candle=0
                color=""
                if (( c > o )); then
                    h_candle=$c
                    l_candle=$o
                    color=$green
                elif (( c == o )); then
                    h_candle=$c
                    l_candle=$o
                    color=$yellow
                else
                    h_candle=$o
                    l_candle=$c
                    color=$red
                fi

                dates[$(( plot_size_x -1 - ${#close[@]} + t ))]=${date[$t]}

                if (( l_candle <= i && i <= h_candle )); then
                    screen[$i,$(( plot_size_x -1 - ${#close[@]} + t ))]=${color}$candle
                elif (( l <= i && i <= h )); then
                    screen[$i,$(( plot_size_x -1 - ${#close[@]} + t ))]=${no_color}$stick
                else
                    screen[$i,$(( plot_size_x -1 - ${#close[@]} + t ))]=" "
                fi
            done
        fi
    done

    text=""
    if (( ${#close[@]} > 0 ));then
        for (( i=plot_size_y-1; i>=-date_size; i-- )); do
            for (( j=0; j<screen_w; j++ )); do
                if (( j>plot_size_x-1 )); then
                    if (( i > 0 )); then
                        text="${text}${prices[$i]:$j-($plot_size_x):1}"
                    fi
                elif (( j==plot_size_x-1 )); then
                    if (( i > 0 )); then
                        text="${text} ${no_color}$stick   "
                    fi
                elif (( i<0 )); then
                    if [ -z "${dates[$j]:$((-i-1)):1}" ]; then
                        text="${text} ${no_color} "
                    else
                        text="${text} ${no_color}${dates[$j]:$((-i-1)):1}"
                    fi
                else
                    text="${text} ${screen[$i,$j]}"
                fi
            done
            text="${text} \n"
        done
    else
        text=$(cat wait_art)
    fi

    tput cup 0 0
    echo -ne "$text"

    sleep 1
done