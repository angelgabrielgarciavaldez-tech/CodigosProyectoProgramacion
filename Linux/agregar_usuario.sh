#!/bin/bash

# =======================================================
# 🚀 Script: Crear y Sincronizar Usuario Linux
# =======================================================
# Descripción: Crea un usuario en Linux, le asigna contraseña, genera 
#              claves SSH, y registra el evento en las tablas de sincronización.
# Uso: sudo ./crear_usuario_linux.sh <username> <password>
# =======================================================

# -----------------------------
# 1. Validación de Argumentos
# -----------------------------
if [ $# -ne 2 ]; then
    echo "Uso: $0 <username> <password>"
    exit 1
fi

USERNAME="$1"
PASSWORD="$2"

# ==================================
# 2. Configuración de Base de Datos
# ==================================
DB_HOST="192.168.2.1"
DB_USER="Proyecto"
DB_PASS="123456789"
DB_NAME="Proyecto"

echo "----- Creando usuario Linux y registrando en BD -----"
echo "Hora: $(date)"
echo "Usuario a procesar: $USERNAME"

# ===============================================
# 3. Crear usuario Linux si no existe
# ===============================================
if ! id "$USERNAME" >/dev/null 2>&1; then
    echo " - Creando usuario en Linux..."
    # useradd -m crea el usuario y su directorio home
    useradd -m "$USERNAME"
    # chpasswd establece la contraseña usando stdin
    echo "$USERNAME:$PASSWORD" | chpasswd
else
    echo " - Usuario ya existe en Linux. Saltando creación."
    # Si existe, solo actualiza la contraseña (opcional)
    echo "$USERNAME:$PASSWORD" | chpasswd
fi

# ===============================================
# 4. Generar llaves SSH si no existen
# ===============================================
SSH_DIR="/home/$USERNAME/.ssh"
if [ ! -f "$SSH_DIR/id_rsa" ]; then
    echo " - Generando llaves SSH (4096 bits)..."
    # Asegura la existencia del directorio .ssh con permisos de usuario
    sudo -u "$USERNAME" mkdir -p "$SSH_DIR"
    # Genera la llave sin passphrase (-N "")
    sudo -u "$USERNAME" ssh-keygen -t rsa -b 4096 -N "" -f "$SSH_DIR/id_rsa" > /dev/null
else
    echo " - Llaves SSH ya existen. No se regeneran."
fi

# ===============================================
# 5. Insertar o Actualizar en la BD (usuarios_sync)
# ===============================================
# ON DUPLICATE KEY UPDATE: Si el usuario existe, actualiza el hash y el estado
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

# ===============================================
# 6. Post-procesamiento en la BD
# ===============================================
EXIT_CODE=$?
echo "Usuario $USERNAME procesado correctamente."
echo "-----------------------------------------------------"

# -----------------------
# 6.1 Registrar log (logs_sync)
# -----------------------
# Obtener ID del usuario recién creado o actualizado
ID_USUARIO=$(mysql -sN -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" \
    -e "SELECT id FROM usuarios_sync WHERE username='$USERNAME' LIMIT 1;")

# Insertar log
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

# -----------------------
# 6.2 Registrar pendiente para Windows (pendientes_sync)
# -----------------------
# Se inserta una tarea para que Windows lo cree/actualice
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
    INSERT INTO pendientes_sync (username, accion, destino, fecha)
    VALUES ('$USERNAME', 'CREAR', 'WINDOWS', NOW())
    ON DUPLICATE KEY UPDATE 
        accion='CREAR', fecha=NOW();
"

# -----------------------
# 6.3 Registrar evento si hubo error (eventos_sync)
# -----------------------
if [ $EXIT_CODE -ne 0 ]; then
    echo "¡Advertencia! Se detectó un error en la última operación de MySQL."
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
        INSERT INTO eventos_sync (username, accion, origen, detalle, fecha)
        VALUES ('$USERNAME', 'CREADO', 'LINUX', 'Error al procesar usuario $USERNAME', NOW());
    "
fi


# -----------------------
# 6.4 Limpiar pendientes_sync si se procesó correctamente
# -----------------------
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
    DELETE FROM pendientes_sync
    WHERE username='$USERNAME'
      AND destino='LINUX';
"
echo " - Pendiente Linux eliminado si existía"

# Leer llave pública del usuario
#PUBLIC_KEY=$(cat "/home/$USERNAME/.ssh/id_rsa.pub")

# Guardar llave en BD
#mysql -u proyecto -pProyecto -h 192.168.2.1 Proyecto \
#-e "UPDATE usuarios_sync SET ssh_key_pub='${PUBLIC_KEY}' WHERE username='${USERNAME}';"
