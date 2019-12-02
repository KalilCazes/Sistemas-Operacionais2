#!/bin/bash
#set -x
function menu() {
    declare -A choices
    re='^[0-9]?$'
    choices=(["petrobras_PETR4"]="petrobras-pn-PETR4" ["magazine_luiza_MGLU3"]="magaz-luiza-on-MGLU3")
    i=1

    echo "Choose stock:"
    echo "================================================"
    for key in "${!choices[@]}"; do
        echo "$i) $key";
        ((i++))
    done
    echo "================================================"

    read -r NUMBER
    if ! [[ "$NUMBER" =~ $re ]] || ((NUMBER <= 0 || NUMBER >= i )) ; then
        echo -e "\nMust be an integer between 1 - $((i-1))";
        exit 1
    fi

    i=1
    for key in "${!choices[@]}"; do
        if ((i==NUMBER)); then
            file_name="./data/${key}_$(date +%H:%M:%S).fk"
            ./crawler.sh "${file_name}" "${choices[$key]}" &
            ./candlestick.sh "${file_name}"
        fi
        ((i++))
    done
}

cleanup() {
    pkill -P $$
    exit 0
}
trap cleanup SIGHUP SIGINT SIGTERM

echo "Type file name to plot old data or press [RETURN] to collect new data:"

read -r INPUT
if [[ "${INPUT}" = "" ]]; then 
    menu

elif [[ -f "${INPUT}" && "${INPUT: -3}" == ".fk" ]]; then 
    file_name="${INPUT}"
    ./candlestick.sh "${file_name}"
else
    echo "File not found or not compatible."
    exit 1
fi


