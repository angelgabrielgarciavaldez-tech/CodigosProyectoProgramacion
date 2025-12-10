#!/bin/bash
# renombrar_usuario.sh
# Uso: ./renombrar_usuario.sh <usuario_actual> <nuevo_usuario>

OLD_USER=$1
NEW_USER=$2

if [[ -z "$OLD_USER" || -z "$NEW_USER" ]]; then
    echo "Faltan parametros: <usuario_actual> <nuevo_usuario>"
    exit 1
fi

echo "----- Renombrando usuario Linux -----"
echo "Usuario actual: $OLD_USER"
echo "Nuevo nombre: $NEW_USER"

# Renombrar usuario local
if id "$OLD_USER" &>/dev/null; then
    sudo usermod -l "$NEW_USER" "$OLD_USER"
    sudo usermod -d /home/"$NEW_USER" -m "$NEW_USER"
    echo " - Usuario renombrado en Linux"
else
    echo " - Usuario no existe en Linux"
    exit 1
fi

# Registrar en base de datos como pendiente
DBUSER="Proyecto"
DBPASS="123456789"
DBHOST="192.168.2.1"
DBNAME="Proyecto"

mysql -u"$DBUSER" -p"$DBPASS" -h "$DBHOST" -D "$DBNAME" -e "
INSERT INTO pendientes_sync (username, accion, destino, procesado)
VALUES ('$OLD_USER','RENOMBRAR','WINDOWS',0)
ON DUPLICATE KEY UPDATE procesado=0;
"

echo " - Pendiente de renombrado agregado para Windows"
echo "-----------------------------------------------"
