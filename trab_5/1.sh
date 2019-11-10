#!/bin/bash

#Exibe uma mensagem, perguntando ao usuário se deseja saber a hora atual.
echo -e "Deseja saber a hora?[SIM/NAO]\n"

#Enquanto o usuário não tiver respondido uma resposta válida, faça:
resposta_aceita=0
while [ "$resposta_aceita" -ne 1 ]; do

	#lê a resposta do usuário e coloca o resultado na variável RESPOSTA.
	read RESPOSTA 

	#Avalia a resposta do usuário de acordo com casos pré definidos.
	case "$RESPOSTA" in

		#Caso o usuário tenha digitado: sim, SIM, s ou S:
		sim | SIM | s | S)

			#Coloca na variável hora_atual o resultado do comando: date | awk '{ print $4 }'
			#O comando date mostra a data e hora atual, mas nós queremos apenas o horário.
			#Pegamos o resultado completo e passamos para o comando awk que irá filtrar o resultado pegando apenas a quarta coluna.
			hora_atual=$(date | awk '{ print $4 }')

			#O conteúdo da variavel hora_atual é exibido na tela.
			echo -e "\nHora atual: ${hora_atual}\n"

			#Declara que o usuário deu uma resposta válida.
			resposta_aceita=1
			;;
		
		#Caso o usuário tenha digitado: n ou N:
		[nN])

			#Exibe uma resposta correspendente. 
			echo -e "\nVolte sempre :)\n"

			#Declara que o usuário deu uma resposta válida.
			resposta_aceita=1
			;;
		
		#Caso o usuário tenha digitado alguma diferente das alternativas anteriores.	
		*)

			#Exibe uma resposta correspendente. 
			echo -e "\nNao foi possivel compreender sua resposta. Responda SIM ou NAO, por favor\n"
			;;
	esac
done

#Exibe uma mensagem, perguntando ao usuário se deseja saber quais usuários estão logados.
echo -e "Deseja saber o(s) usuario(s) logado(s)?[SIM/NAO]\n"

#Enquanto o usuário não tiver respondido uma resposta válida, faça:
resposta_aceita=0
while [ "$resposta_aceita" -ne 1 ]; do

	#lê a resposta do usuário e coloca o resultado na variável RESPOSTA.
	read RESPOSTA 

	#Avalia a resposta do usuário de acordo com casos pré definidos.
	case "$RESPOSTA" in

		#Caso o usuário tenha digitado: sim, SIM, s ou S:
		sim | SIM | s | S)

			#Coloca na variável usuarios_logados o resultado do comando: w | awk '{print $1}' | uniq | sed '1d;2d'
			#O comando w exibe informações a respeito dos usuários logados. Nós apenas queremos listar seus nomes.
			#O resultado é passado para o comando awk que filtra pela primeira coluna. No entanto, ela ainda contém informações a mais.
			#O resultado é passado para a função uniq, que irá retirar qualquer linha que se repita. No entanto, ainda precisamos remover as duas primeiras linhas, que contém cabeçalhos.
			#O resultado é passado para a função sed, que irá remover as primeiras duas linhas.
			usuarios_logados=$(w | awk '{print $1}' | uniq | sed '1d;2d')

			#O conteúdo da variavel usuarios_logados é exibido na tela.
			echo -e "\nUsuario(s) logado(s):${usuarios_logados}\n"

			#Declara que o usuário deu uma resposta válida.
			resposta_aceita=1
			;;
		
		#Caso o usuário tenha digitado: n ou N:
		[nN])

			#Exibe uma resposta correspendente. 
			echo -e "\nVolte sempre :)\n"

			#Declara que o usuário deu uma resposta válida.
			resposta_aceita=1
			;;
		
		#Caso o usuário tenha digitado alguma diferente das alternativas anteriores.
		*)

			#Exibe uma resposta correspendente. 
			echo -e "\nNao foi possivel compreender sua resposta. Responda SIM ou NAO, por favor\n"
			;;

	esac
done

#Exibe uma mensagem, perguntando ao usuário se deseja saber informações sobre a utilização do disco.
echo -e "Deseja saber o uso do disco?[SIM/NAO]\n"

#Enquanto o usuário não tiver respondido uma resposta válida, faça:
resposta_aceita=0
while [ "$resposta_aceita" -ne 1 ]; do

	#lê a resposta do usuário e coloca o resultado na variável RESPOSTA.
	read RESPOSTA 

	#Avalia a resposta do usuário de acordo com casos pré definidos.
	case "$RESPOSTA" in

		#Caso o usuário tenha digitado: sim, SIM, s ou S:
		sim | SIM | s | S)
			
			#Coloca na variável uso_disco o resultado do comando: df -h | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5  "\t" $6}
			#O comando df -h nos mostra algumas informações sobre a utiilização do disco.
			#O resultado é passado para função awk, que irá filtrar pelas colunas que estamos realmente interessados.
			uso_disco=$(df -h | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5  "\t" $6}')
			
			#O conteúdo da variavel uso_disco é exibido na tela.
			echo -e "\nUso do disco:\n${uso_disco}"
			
			#Declara que o usuário deu uma resposta válida.
			resposta_aceita=1
			;;
		[nN])
			
			#Exibe uma resposta correspendente. 
			echo -e "\nVolte sempre :)\n"
			
			#Declara que o usuário deu uma resposta válida.
			resposta_aceita=1
			;;
		*)

			#Exibe uma resposta correspendente. 
			echo -e "\nNao foi possivel compreender sua resposta. Responda SIM ou NAO, por favor\n"
			;;

	esac
done

