#!/bin/bash

DB_HOST="192.168.2.1"
DB_USER="Proyecto"
DB_PASS="123456789"
DB_NAME="Proyecto"

# -----------------------------
# 1. Pedir ID del usuario
# -----------------------------
USUARIO_ID=$(dialog --inputbox "Ingresa el ID del usuario para ver archivos compartidos:" 10 50 3>&1 1>&2 2>&3)

# Cancelar si no se ingresa nada
if [ -z "$USUARIO_ID" ]; then
    exit 0
fi

# -----------------------------
# 2. Buscar archivos compartidos con ese usuario
# -----------------------------
ARCHIVOS=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -N -e \
"SELECT ruta_archivo FROM archivos_compartidos WHERE contacto_id=$USUARIO_ID")

# -----------------------------
# 3. Mostrar resultado
# -----------------------------
if [ -z "$ARCHIVOS" ]; then
    dialog --msgbox "❌ El usuario ID $USUARIO_ID no tiene archivos compartidos." 10 50
else
    LISTA=""
    while read -r RUTA; do
        NOMBRE=$(basename "$RUTA")
        LISTA="$LISTA\n- $NOMBRE"
    done <<< "$ARCHIVOS"

    dialog --msgbox "✅ Archivos compartidos con el usuario ID $USUARIO_ID:\n$LISTA" 15 60
fi
