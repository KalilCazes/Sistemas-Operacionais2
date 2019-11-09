
#!/bin/bash

arg1=$1
arg2=$2

if [[ ${arg2} == *${arg1}* ]]; then
	echo "${arg1} esta continda em ${arg2}"
fi
