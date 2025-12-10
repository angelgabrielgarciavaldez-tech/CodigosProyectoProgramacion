#!/bin/bash

WIN_USER="Administrador"
WIN_HOST="192.168.2.1"
SSH_KEY="$HOME/.ssh/id_rsa"  # Asegúrate de usar la llave correcta sin passphrase

# Función para mostrar info de discos de Windows
function mostrar_discos_windows() {
    INFO=$(ssh -i "$SSH_KEY" "$WIN_USER@$WIN_HOST" "powershell -Command \
'Get-Disk | Format-Table Number,FriendlyName,OperationalStatus,Size,PartitionStyle -AutoSize; \
 Get-Volume | Format-Table DriveLetter,FileSystemLabel,FileSystem,Size,SizeRemaining,HealthStatus -AutoSize; \
 Get-Partition | Format-Table DiskNumber,PartitionNumber,Size,Type,GptType -AutoSize'")
    
    # Mostrar en ventana dialog
    dialog --backtitle "Discos Windows" --title "Informacion de Discos" --msgbox "$INFO" 25 100
}

# Menú principal
while true; do
    OPCION=$(dialog --clear --backtitle "Menu Discos" \
        --title "Opciones" \
        --menu "Selecciona una opcion:" 15 60 4 \
        1 "Mostrar discos de Windows" \
        2 "Salir" 3>&1 1>&2 2>&3)

    case $OPCION in
        1) mostrar_discos_windows ;;
        2) clear; exit ;;
    esac
done
