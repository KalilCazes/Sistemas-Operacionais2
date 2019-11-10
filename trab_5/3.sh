echo -e "\nDigite o primeiro número:\n"

resposta_aceita=0
while [ "$resposta_aceita" -ne 1 ]; do

    read num_1

    re='^[+-]?[0-9]+([.][0-9]+)?$'
    if ! [[ $num_1 =~ $re ]] ; then
        echo -e "\nNúmero inválido. Digite novamente:\n"
    else
        resposta_aceita=1
    fi
done

echo -e "\nDigite o segundo número:\n"

resposta_aceita=0
while [ "$resposta_aceita" -ne 1 ]; do

    read num_2

    re='^[+-]?[0-9]+([.][0-9]+)?$'
    if ! [[ $num_2 =~ $re ]] ; then
        echo -e "\nNúmero inválido. Digite novamente:\n"
    else
        resposta_aceita=1
    fi
done

if [ "$num_1" -gt "$num_2" ]
then
    echo -e "\n$num_1 é maior que $num_2"
else
    if [ "$num_1" -lt "$num_2" ]
    then
        echo -e "\n$num_1 é menor que $num_2"
    else
        echo -e "\n$num_1 é igual a $num_2"
    fi
fi