#!/bin/bash

echo "¡Bienvenido al modulo de Despliegues!"

# ASCII art de un perro
echo "  / \\__"
echo " (    @\\___"
echo " /         O"
echo "/   (_____/"
echo "/_____/   U"
echo
opc=0

while [ $opc -ne 9 ]; do
    clear
    echo "[Selecciona la opcion correcta]"
    echo "1: Obtener submodules"
    echo "2: Compilar Postgres y Desplegar Servidor"
    echo "3: Compilar sin cache Postgres"
    echo "4: Compilar Backend y Desplegar a Servidor"
    echo "5: Compilar Frontend y Desplegar a Servidor"
    echo "6: Desplegar Ambos Local"
    echo "7: Salir"
    
    read -p "Seleccione una opcion: " opc
    
    case $opc in
        1)
            git submodule update --remote --recursive
            echo "Actualización correcta"
            ;;
        2)
            docker build -t postgres14.6:latest -f postgres14.dockerfile .
            if [ $? -eq 0 ]; then
                echo "Compilación de postgres correcta"
            else
                echo "Error en la compilación de postgres"
            fi
            docker stack deploy -c pull_database.yml basedatos
            ;;
        3)
            docker build -t postgres14.6:latest -f postgres14.dockerfile . --no-cache
            if [ $? -eq 0 ]; then
                echo "Compilación de postgres sin cache realizada correctamente"
            else
                echo "Error en la compilación de postgres sin cache"
            fi
            docker stack deploy -c pull_database.yml basedatos
            ;;
        4)
            docker build -t turnos_back:v1 -f backend.dockerfile .
            echo "Compilación de Backend correcta"
            ;;
        5)
            docker build -t turnos_web:v1 -f nginx.dockerfile .
            echo "Compilación de Frontend correcta"
            ;;
        6)
            docker stack deploy -c turnos.yml turnos
            echo "Despliegue realizado con éxito"
            ;;
        7)
            exit
            ;;
        *)
            echo "Opción incorrecta"
            ;;
    esac
done
