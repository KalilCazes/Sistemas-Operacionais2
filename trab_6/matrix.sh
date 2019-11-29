#!/bin/bash

screen_w=$(($(tput cols)/2))
screen_h_hidden=20
screen_h_real=$(tput lines)
screen_h=$((screen_h_hidden+screen_h_real))

db_type=""
piped_db=""

declare -A screen
declare -a db=()

function update_db {

    case "$db_type" in
        x)
            words=$(sh $1)
            db=()
            for word in $words; do
                db+=("$word")
            done
            ;;
        i)
            words="$piped_db"
            db=()
            for word in $words; do
                db+=("$word")
            done
            ;;
        *)
            size=$((($RANDOM % 10)+5))
            w=$(LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c $size ; echo)
            db+=($w)  
            ;;
    esac
}

function add_words {

    n_words=2

    for (( i=0; i<n_words; i++ )); do

        rand_word_i=$[$RANDOM % ${#db[@]}]
        rand_word=${db[$rand_word_i]}

        found_spot=0
        attempts=0
        while [ "$found_spot" -ne 1 ] && (( attempts < 10 )); do

            max_i=$(($screen_h-(screen_h_hidden/2)-screen_h_real-${#rand_word}))
            if ((max_i<=0)); then
                max_i=1
            fi
            
            w_init_i=$[$RANDOM % $max_i ]
            w_j=$[$RANDOM % $screen_w]

            found_spot=1
            attempts=$((attempts+1))
            for (( w_i=w_init_i; w_i<2+w_init_i+${#rand_word}; w_i++ )); do
                if [ "${screen[$w_i,$w_j]}" != " " ]; then
                    found_spot=0
                fi
            done

        done

        if (( attempts >= 10 )); then
            break
        fi

        for (( w_i=w_init_i; w_i<w_init_i+${#rand_word}; w_i++ )); do
            screen[$w_i,$w_j]=${rand_word:$w_i-$w_init_i:1}
        done
    
    done
}


function set_up {

    tput reset

    echo -ne "\033[1;32m"

    for ((i=0;i<=screen_h;i++)) do
        for ((j=0;j<=screen_w;j++)) do
            screen[$i,$j]=" "
            prev_screen[$i,$j]=" "
        done
    done

}

function main_loop {

    end_loop=0
    while [ "$end_loop" -ne 1 ]; do

        declare -A old_screen
        
        text=""
        for (( i=0; i<screen_h; i++ )); do
            for (( j=0; j<screen_w; j++ )); do
                old_screen[$i,$j]="${screen[$i,$j]}"
                if ((i>screen_h_hidden));then
                    text="${text} ${old_screen[$i,$j]}"
                fi
                if ((i>0));then
                    screen[$i,$j]=${old_screen[$(($i-1)),$j]}
                else
                    screen[$i,$j]=" "
                fi
            done
            if ((i>screen_h_hidden));then
                text="${text} \n"
            fi
        done
        tput cup 0 0
        echo -ne "$text"

        update_db $1
        add_words
    done
}

while getopts "xhi" arg; do
    case "$arg" in
    x) 
        if [ -x $2 ]; then
            db_type="x"
        else
            echo "Nenhum executável escolhido."
            exit 0
        fi 	
        ;;
    i)
        db_type="i"
        read piped_db
        ;;
    h)  
        echo -e "Utilização: $(basename $0) [OPÇÕES]..."
        echo -e "Terminal Matrix.\n"
        echo -e " -f EXECUTAVEL\tO conteúdo da matrix será o output de um shell script executável."
        echo -e " -h\t\Ajuda (esta tela).\n"
        exit 0
        ;;
    *)
        db_type="d"
        ;;
    esac
done

set_up
main_loop $2