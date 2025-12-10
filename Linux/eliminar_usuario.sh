#!/bin/bash
# eliminar_usuario.sh
# Uso: ./eliminar_usuario.sh <usuario>

USER_TO_DELETE=$1

if [[ -z "$USER_TO_DELETE" ]]; then
    echo "Falta el nombre de usuario"
    exit 1
fi

echo "----- Eliminando usuario Linux -----"
echo "Usuario: $USER_TO_DELETE"

# Eliminar usuario local
if id "$USER_TO_DELETE" &>/dev/null; then
    sudo deluser --remove-home "$USER_TO_DELETE"
    echo " - Usuario y home eliminados en Linux"
else
    echo " - Usuario no existe en Linux"
fi

# Registrar en base de datos MySQL como pendiente
DBUSER="Proyecto"
DBPASS="123456789"
DBHOST="192.168.2.1"
DBNAME="Proyecto"

mysql -u"$DBUSER" -p"$DBPASS" -h "$DBHOST" -D "$DBNAME" -e "
INSERT INTO pendientes_sync (username, accion, destino, procesado)
VALUES ('$USER_TO_DELETE','ELIMINAR','WINDOWS',0)
ON DUPLICATE KEY UPDATE procesado=0;
"

echo " - Pendiente de eliminacion agregado para Windows"
echo "-----------------------------------------------"

# Marcar en BD como eliminado
mysql -u"$DBUSER" -p"$DBPASS" -h "$DBHOST" -D "$DBNAME" -e "
UPDATE usuarios_sync SET linux_estado='eliminado', ultima_actualizacion=NOW()
WHERE username='$USER_TO_DELETE';
"
