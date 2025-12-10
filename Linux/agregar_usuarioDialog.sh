#!/bin/bash

# =======================================================
# 🚀 Script: Crear y Sincronizar Usuario Linux (con dialog)
# =======================================================

# ---------------------------------------
# Configuración de Base de Datos
# ---------------------------------------
DB_HOST="192.168.2.1"
DB_USER="Proyecto"
DB_PASS="123456789"
DB_NAME="Proyecto"

# ---------------------------------------
# 1. Pedir nombre de usuario con dialog
# ---------------------------------------
USERNAME=$(dialog --title "Crear Usuario Linux" \
--inputbox "Ingrese el nombre de usuario:" 8 40 3>&1 1>&2 2>&3)

# Verificar si se canceló
if [ $? -ne 0 ] || [ -z "$USERNAME" ]; then
    dialog --msgbox "Operación cancelada." 6 30
    clear
    exit 1
fi

# ---------------------------------------
# 2. Pedir contraseña con dialog
# ---------------------------------------
PASSWORD=$(dialog --title "Crear Usuario Linux" \
--passwordbox "Ingrese la contraseña del usuario:" 8 40 3>&1 1>&2 2>&3)

# Verificar si se canceló
if [ $? -ne 0 ] || [ -z "$PASSWORD" ]; then
    dialog --msgbox "Operación cancelada." 6 30
    clear
    exit 1
fi

# ---------------------------------------
# 3. Crear usuario Linux si no existe
# ---------------------------------------
if ! id "$USERNAME" >/dev/null 2>&1; then
    useradd -m "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
else
    echo "$USERNAME:$PASSWORD" | chpasswd
fi

# ---------------------------------------
# 4. Generar llaves SSH si no existen
# ---------------------------------------
SSH_DIR="/home/$USERNAME/.ssh"
if [ ! -f "$SSH_DIR/id_rsa" ]; then
    sudo -u "$USERNAME" mkdir -p "$SSH_DIR"
    sudo -u "$USERNAME" ssh-keygen -t rsa -b 4096 -N "" -f "$SSH_DIR/id_rsa" > /dev/null
fi

# ---------------------------------------
# 5. Insertar o actualizar en la BD
# ---------------------------------------
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
INSERT INTO usuarios_sync
    (username, password_hash, creado_en, linux_estado, windows_estado, fecha_creado)
VALUES
    ('$USERNAME', '$PASSWORD', 'linux', 'ok', 'pendiente', NOW())
ON DUPLICATE KEY UPDATE
    password_hash='$PASSWORD',
    linux_estado='ok',
    ultima_actualizacion=NOW();
"

# ---------------------------------------
# 6. Registrar log
# ---------------------------------------
ID_USUARIO=$(mysql -sN -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" \
    -e "SELECT id FROM usuarios_sync WHERE username='$USERNAME' LIMIT 1;")

mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
INSERT INTO logs_sync (id_usuario_sync, evento, sistema, mensaje, fecha)
VALUES (
    $ID_USUARIO,
    'CREADO',
    'linux',
    'Usuario procesado correctamente en Linux',
    NOW()
);
"

# ---------------------------------------
# 7. Confirmación con dialog
# ---------------------------------------
dialog --msgbox "Usuario '$USERNAME' creado correctamente." 6 50
clear
