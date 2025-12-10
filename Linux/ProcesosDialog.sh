#!/bin/bash

# =======================================================
# 🚀 Script: Ver y matar procesos Windows remoto (con dialog)
# =======================================================

WIN_USER="Administrador"
WIN_HOST="192.168.2.1"

while true; do
    # ---------------------------------------
    # 1. Obtener procesos desde Windows
    # ---------------------------------------
    PROCESOS=$(ssh $WIN_USER@$WIN_HOST "powershell -Command \"Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 | Format-Table Id,ProcessName,CPU,WS -AutoSize | Out-String\"")

    # Mostrar procesos en un dialog textbox
    dialog --title "Procesos en $WIN_HOST" --msgbox "$PROCESOS" 20 80

    # ---------------------------------------
    # 2. Pedir PID o nombre del proceso
    # ---------------------------------------
    PROCESO=$(dialog --inputbox "Escribe el PID o nombre del proceso a matar\n(o deja vacío y presiona Cancelar para salir):" 8 50 3>&1 1>&2 2>&3)

    # Verificar si canceló o dejó vacío
    if [ $? -ne 0 ] || [ -z "$PROCESO" ]; then
        dialog --msgbox "Saliendo del gestor de procesos." 6 40
        clear
        break
    fi

    # ---------------------------------------
    # 3. Confirmar eliminación
    # ---------------------------------------
    dialog --yesno "¿Seguro que deseas eliminar el proceso '$PROCESO'?" 7 50
    if [ $? -ne 0 ]; then
        continue
    fi

    # ---------------------------------------
    # 4. Ejecutar eliminación
    # ---------------------------------------
    if [[ "$PROCESO" =~ ^[0-9]+$ ]]; then
        ssh $WIN_USER@$WIN_HOST "powershell -Command \"Stop-Process -Id $PROCESO -Force\""
    else
        ssh $WIN_USER@$WIN_HOST "powershell -Command \"Get-Process -Name '$PROCESO' | Stop-Process -Force\""
    fi

    # ---------------------------------------
    # 5. Confirmación
    # ---------------------------------------
    dialog --msgbox "Proceso '$PROCESO' eliminado (si existía)." 6 50
done

clear
