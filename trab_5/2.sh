#!/bin/bash

echo -e "Digite um nome para o arquivo\n"
read NOME

if [ -e ${NOME} ]; then
	echo -e "O arquivo existe."
	if [ -d ${NOME} ]; then
		echo -e "${NOME} e um diretorio.\n"
	elif [ -f ${NOME} ]; then
		echo -e "${NOME} e um arquivo regular.\n"
	fi
	else
		echo "O arquivo nao existe."
fi 	


