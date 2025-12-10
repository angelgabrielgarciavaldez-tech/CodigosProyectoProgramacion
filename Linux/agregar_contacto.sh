#!/bin/bash

# ==============================
# Script: Agregar Contacto
# ==============================

# Configuración DB
DB_HOST="192.168.2.1"
DB_USER="Proyecto"
DB_PASS="123456789"
DB_NAME="Proyecto"

# Comprobar dialog instalado
if ! command -v dialog &> /dev/null; then
    echo "Instalando dialog..."
    sudo apt install -y dialog
fi

# Pedir usuario principal
PRINCIPAL=$(dialog --stdout --inputbox "Ingrese su nombre de usuario:" 8 40)

if [ -z "$PRINCIPAL" ]; then
    exit 1
fi

# Obtener ID del usuario principal
USER_ID=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -s -N \
    -e "SELECT id FROM usuarios_sync WHERE username='$PRINCIPAL';")

if [ -z "$USER_ID" ]; then
    dialog --title "❌ Error" --msgbox "Usuario '$PRINCIPAL' no existe en la base de datos." 8 50
    exit 1
fi

# Pedir usuario contacto
CONTACTO=$(dialog --stdout --inputbox "Ingrese nombre del contacto a agregar:" 8 50)

if [ -z "$CONTACTO" ]; then
    exit 1
fi

# Obtener ID del contacto
CONTACT_ID=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -s -N \
    -e "SELECT id FROM usuarios_sync WHERE username='$CONTACTO';")

if [ -z "$CONTACT_ID" ]; then
    dialog --title "❌ Error" --msgbox "El contacto '$CONTACTO' no existe en la base de datos." 8 60
    exit 1
fi

# Verificar si ya existe relación
EXISTE=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -s -N \
    -e "SELECT 1 FROM contactos WHERE usuario_id=$USER_ID AND contacto_id=$CONTACT_ID;")

if [ "$EXISTE" == "1" ]; then
    dialog --title "⚠️ Ya existe" --msgbox "El contacto ya está agregado." 8 50
    exit 0
fi

# Insertar contacto
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -s -N \
    -e "INSERT INTO contactos (usuario_id, contacto_id, puede_enviar_archivos) VALUES ($USER_ID, $CONTACT_ID, 1);"

# Éxito
dialog --title "✔ Listo" --msgbox "Contacto '$CONTACTO' agregado exitosamente." 8 50
