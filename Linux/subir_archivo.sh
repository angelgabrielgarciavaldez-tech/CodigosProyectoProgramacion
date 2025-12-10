#!/bin/bash

# Verificar si dialog está instalado
if ! command -v dialog &> /dev/null; then
    echo "Instalando dialog..."
    sudo apt install -y dialog
fi

# =======================================
# Configuración
# =======================================
DB_HOST="192.168.2.1"
DB_USER="Proyecto"
DB_PASS="123456789"
DB_NAME="Proyecto"

REMOTE_USER="angelg"
REMOTE_IP="192.168.2.2"
REMOTE_DIR="/srv/archivos"

# =======================================
# Seleccionar usuario
# =======================================
USUARIO=$(dialog --title "Usuario" --inputbox "Ingresa tu nombre de usuario (Linux/DB):" 10 50 2>&1 >/dev/tty)

if [ -z "$USUARIO" ]; then
    dialog --msgbox "❌ No ingresaste usuario" 8 40
    clear
    exit 1
fi

# Obtener ID del usuario
USUARIO_ID=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -se \
"SELECT id FROM usuarios_sync WHERE username='$USUARIO';")

if [ -z "$USUARIO_ID" ]; then
    dialog --msgbox "❌ Usuario no existe en la Base de Datos" 8 45
    clear
    exit 1
fi

# =======================================
# Seleccionar archivo local
# =======================================
ARCHIVO=$(dialog --title "Seleccionar Archivo" --fselect "$HOME/" 15 60 2>&1 >/dev/tty)

if [ ! -f "$ARCHIVO" ]; then
    dialog --msgbox "❌ Archivo no válido" 8 40
    clear
    exit 1
fi

# =======================================
# Pedir ID del contacto con quien se comparte
# =======================================
CONTACTO_ID=$(dialog --title "Contacto" --inputbox "Ingresa el ID del contacto con quien compartes el archivo:" 10 50 2>&1 >/dev/tty)

if [ -z "$CONTACTO_ID" ]; then
    dialog --msgbox "❌ Debes ingresar un contacto" 8 40
    clear
    exit 1
fi

# =======================================
# Subir archivo vía SCP
# =======================================
dialog --infobox "📤 Subiendo archivo, espera..." 5 40

ssh $REMOTE_USER@$REMOTE_IP "mkdir -p $REMOTE_DIR/$USUARIO"

scp "$ARCHIVO" $REMOTE_USER@$REMOTE_IP:$REMOTE_DIR/$USUARIO/ &>/dev/null
if [ $? -ne 0 ]; then
    dialog --msgbox "❌ Error al subir archivo" 8 40
    clear
    exit 1
fi

# Insertar en BD
NOMBRE_ARCHIVO=$(basename "$ARCHIVO")
RUTA="$REMOTE_DIR/$USUARIO/$NOMBRE_ARCHIVO"

mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" \
    -e "INSERT INTO archivos_compartidos (usuario_id, contacto_id, ruta_archivo, cifrado)
        VALUES ($USUARIO_ID, $CONTACTO_ID, '$RUTA', 0);"

dialog --msgbox "✔ Archivo subido correctamente y registrado en BD" 8 50
clear
exit 0
