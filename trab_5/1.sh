#!/bin/bash

echo -e "Deseja saber a hora?[SIM/NAO]"
read RESPOSTA 

case "$RESPOSTA" in
	sim | SIM | s | S)
	hora_atual=$(date | awk '{ print $4 }')
	echo -e "Hora atual: ${hora_atual}\n"
	;;
 	[nN])
	echo -e "Volte sempre :)\n"
	;;
	*)
	echo -e "Nao foi possivel compreender sua resposta. Responda SIM ou NAO, por favor\n"
	;;
esac

echo -e "Deseja saber o(s) usuario(s) logado(s)?[SIM/NAO]"
read RESPOSTA 

case "$RESPOSTA" in
	sim | SIM | s | S)
	usuarios_logados=$(w | awk '{print $1}' | uniq | sed '1d;2d')
	echo -e "Usuario(s) logado(s):${usuarios_logados}\n"
	;;
 	[nN])
	echo -e "Volte sempre :)\n"
	;;
	*)
	echo -e "Nao foi possivel compreender sua resposta. Responda SIM ou NAO, por favor\n"
	;;

esac

echo -e "Deseja saber o uso do disco?[SIM/NAO]"
read RESPOSTA 

case "$RESPOSTA" in
	sim | SIM | s | S)
	uso_disco=$(df -h | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5  "\t" $6}')
	echo -e "Uso do disco:\n${uso_disco}"
	;;
 	[nN])
	echo -e "Volte sempre :)\n"
	;;
	*)
	echo -e "Nao foi possivel compreender sua resposta. Responda SIM ou NAO, por favor\n"
	;;

esac


