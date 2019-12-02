#!/bin/bash

cleanup() {
    pkill -P $$
    exit 0
}
trap cleanup SIGHUP SIGINT SIGTERM

echo "Type file name to plot old data or press [RETURN] to collect new data:"

read -r INPUT
if [[ "${INPUT}" = "" ]]; then 
    file_name="./data/data_$(date +%H:%M:%S).fk"
    ./crawler.sh "${file_name}" & 
    ./candlestick.sh "${file_name}"

elif [[ -f "${INPUT}" && "${INPUT: -3}" == ".fk" ]]; then 
    file_name="${INPUT}"
    ./candlestick.sh "${file_name}"
else
    echo "File not found or not compatible."
    exit 1
fi


