#!/bin/bash

# =======================================================
# 🚀 Script: Eliminar Usuario Linux (con dialog)
# =======================================================

# ---------------------------------------
# Configuración de Base de Datos
# ---------------------------------------
DB_HOST="192.168.2.1"
DB_USER="Proyecto"
DB_PASS="123456789"
DB_NAME="Proyecto"

# ---------------------------------------
# 1. Pedir nombre de usuario a eliminar
# ---------------------------------------
USER_TO_DELETE=$(dialog --title "Eliminar Usuario Linux" \
--inputbox "Ingrese el nombre del usuario a eliminar:" 8 40 3>&1 1>&2 2>&3)

# Verificar si se canceló
if [ $? -ne 0 ] || [ -z "$USER_TO_DELETE" ]; then
    dialog --msgbox "Operación cancelada." 6 30
    clear
    exit 1
fi

# ---------------------------------------
# 2. Confirmar eliminación
# ---------------------------------------
dialog --title "Confirmar Eliminación" \
--yesno "¿Está seguro que desea eliminar al usuario '$USER_TO_DELETE'?" 7 50

if [ $? -ne 0 ]; then
    dialog --msgbox "Operación cancelada." 6 30
    clear
    exit 1
fi

# ---------------------------------------
# 3. Eliminar usuario Linux si existe
# ---------------------------------------
if id "$USER_TO_DELETE" &>/dev/null; then
    sudo deluser --remove-home "$USER_TO_DELETE"
    MSG_LINUX="Usuario y home eliminados en Linux"
else
    MSG_LINUX="Usuario no existe en Linux"
fi

# ---------------------------------------
# 4. Registrar pendiente para Windows
# ---------------------------------------
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
INSERT INTO pendientes_sync (username, accion, destino, procesado)
VALUES ('$USER_TO_DELETE','ELIMINAR','WINDOWS',0)
ON DUPLICATE KEY UPDATE procesado=0;
"

# ---------------------------------------
# 5. Marcar en BD como eliminado
# ---------------------------------------
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
UPDATE usuarios_sync 
SET linux_estado='eliminado', ultima_actualizacion=NOW()
WHERE username='$USER_TO_DELETE';
"

# ---------------------------------------
# 6. Mensaje final con dialog
# ---------------------------------------
dialog --msgbox "Resultado:\n$MSG_LINUX\nPendiente agregado para Windows." 8 50
clear
