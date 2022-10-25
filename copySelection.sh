#!/bin/bash

								#Al principio del Script comprobaremos que nos pongan 3 argumento

if test $# -ge 3
	then
	echo "Parametros correctos" 
	echo "$HOSTNAME"        #Usuario
	echo $BASH_VERSION		#Version del bash
	Fecha=`date +"%d/%m/%Y"`
	Hora=`date +"%H:%M"`
	echo "$Fecha,$Hora"		#Fecha

	if test -d $1	#Comprobamos que el argumento 1 sea un directorio
		then	
		echo "$1.......Directorio correcto"
		ARG1=$1		#Guardamos el directorio 1 en una variable por si lo queremos modificar después	
		
		
		else 
		
		
		echo "$1 No es un directorio"
		exit 1
	fi
	if test -d $2	#Comprobamos que el argumento 2 sea un directorio
		then	
		echo "$2.......Directorio correcto"
		ARG2=$2		#Guardamos el directorio 2 en una variable por si lo queremos modificar después	
		
		
		else 
		
		
		echo "$2 No es un directorio"
		exit 1
	fi




shift 				#Con el comando Shift moveremos sacando de la cola de izquierda a derecha expulsando $1
shift 				#Moveremos el $2 a $1 y ahora con este shift lo expulsaremos de la cola

cd $ARG2 
Antes_De_Copiar_Archivos=`find . -type f | wc -l` 
Antes_De_Copiar_Directorios=`find . -type d | wc -l`
echo "Numero de archivos antes de copiar $Antes_De_Copiar_Archivos"
echo "Numero de Directorios antes de copiar $Antes_De_Copiar_Directorios"  

for i in "$@"; do   #Bucle for con el que iteraremos por cada argumento
find $ARG1 -type f -name "*.$i" -exec cp --parents -f {} $ARG2 \; 
					#Esto al ser un poco mas largo lo comentaré en las proximos lineas
					#Empecemos comentando el comando "Find" que buscará todos los archivos que se con la extensión pasada por el 						
					#iterador de extensiones
					#Sabiendo que existe el cp --parents que copia los path de cada archivo de forma completa a otro directorio
					#Se podria utilizar tambien la sentencia | xargs -t con el path es decir con el argumento 2 pasado por teclado
					#Pero esta técnica es más eficinete con un número significante de archivos. Podría ser mejor dejarlo puesto desde 						
					#un principio pero he decidido -exec por que me parece mas sencillo de implementar y entender el código ya que 						
					#simplemnte a breves palabras sirve como una condicion ya que condiciona el cp --parents con un -f Haciendo que 					
					#copie solo ficheros
done
cd $ARG2			#Nos colocaremos el directorio destino (Segundo argumento que se pasa por teclado) 
					#Lo que he hecho para poder saber cuantos archivos/directorios han sido copiados
					#Simplemente ha sido una pequeña operación aritmetica en la que se resta el numero de archivos/directorios totales
					#A los ficheros/Directorios iniciales 
					
Despues_de_Copiar_Archivos=`find . -type f | wc -l`
Despues_de_Copiar_Directorios=`find . -type d | wc -l`
		
echo "El numero de archivos copiados es : `expr $Despues_de_Copiar_Archivos - $Antes_De_Copiar_Archivos`" 
echo "El numero de directorios copiados es : `expr $Despues_de_Copiar_Directorios - $Antes_De_Copiar_Directorios`"


else 
echo "No has pasado al menos 3 argumentos"


Nocopia(){
cd $ARG1
Numero_de_ficheros_a_copiar= `find . -type f | wc -l`
Numero_de_ficheros_copiados= `expr $Despues_de_Copiar_Archivos - $Antes_De_Copiar_Archivos`

if  [ "$Numero_de_ficheros_a_copiar" -eq "$Numero_de_ficheros_copiados" ]
then
		echo "No ha habido ningún fichero que no se haya copiado"
		Copia(){
			if  [ "$Numero_de_ficheros_copiados" -ge 1 ]
			then
			echo "Hay al menos 1 fichero que se ha copiado"
			return 0
			fi
		}
	else
return 1
fi
}




ErrorFATAL(){
if  [ "$Numero_de_ficheros_copiados" -eq 0 ]
then
echo "No se ha copiado ningún fichero"
return 2
fi
}


#Aunque no este 100% Implementado dejo por aqui la explicacion de como funcionarian las 3 funciones que dirian los valores de retonro
#Empezaremos con la primera "Nocopia()" la cual comparara si es igual los ficheros que se han copiado con los que se tenian que copiar
#Si no son iguales sabremos que al menos 1 no se ha copiado y tendrá un valor de retorno 1(Como pone en en el enunciado de la práctica)
#Entrando en el bucle siendo la condicion verdadera nos encontrariamos la segunda funcion "Copia()"la cual comprobará si al menos 1 fichero 
#ha sido copiado siendo los valores de entrada del bucle (1,infinito) si de un intervalo se tratara. Devolviendo 0 como indica el enunciado de la practica

#Para acabar la funcion "ErrorFATAL()" comprobara que si ningun archivo ha sido copiado devolverá 2 como retorno de carro
#Faltaria por implementar la llamada a la función dentro del script pero lamentandolo mucho no se al igual que una vez implementado también se deberían crear
#otras sentencias condicionales para cuando se efectuaran los bucles dando lugar por ejemplo que si el valor de retorno es por ejemplo 1 de la opcion de si quiere borrar
#los ficheros que si se han copiado correctamente como muchos otros ejemplos más

fi
#Nocopia
#ErrorFATAL
