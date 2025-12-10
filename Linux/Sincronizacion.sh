#!/bin/bash

# ==== CONFIGURACION ====
DBHost="192.168.2.1"
DBUser="Proyecto"
DBPass="123456789"
DBName="Proyecto"

MYSQL="mysql -u$DBUser -p$DBPass -h $DBHost $DBName -sN"

echo "===== SINCRONIZACION LINUX ====="

# Obtener pendientes para Linux
Acciones=$($MYSQL -e "SELECT id, username, accion FROM pendientes_sync WHERE destino='LINUX' AND procesado=0;")

if [ -z "$Acciones" ]; then
    echo "No hay acciones pendientes."
    exit 0
fi

# Procesar cada pendiente
while IFS=$'\t' read -r ID Usuario Operacion; do
    [ -z "$ID" ] && continue
    Operacion=$(echo "$Operacion" | tr '[:lower:]' '[:upper:]')

    echo ""
    echo "=== Procesando: $Operacion | Usuario: $Usuario ==="

    success=false
    errorMessage=""

    # Obtener password si se necesita
    if [ "$Operacion" != "ELIMINAR" ]; then
        plainPassword=$($MYSQL -e "SELECT password_hash FROM usuarios_sync WHERE username='$Usuario' ORDER BY id DESC LIMIT 1;")
    fi

    case $Operacion in
        "CREAR")
            if ! id "$Usuario" &>/dev/null; then
                sudo useradd -m "$Usuario"
                echo "$plainPassword" | sudo passwd --stdin "$Usuario" &>/dev/null
                mkdir -p /home/$Usuario/.ssh
                ssh-keygen -t rsa -b 4096 -f /home/$Usuario/.ssh/id_rsa -N "" &>/dev/null
                chown -R $Usuario:$Usuario /home/$Usuario/.ssh
                echo " - Usuario creado en Linux"
            else
                echo " - Usuario ya existe en Linux"
            fi
            success=true
            ;;
        "MODIFICAR")
            if id "$Usuario" &>/dev/null; then
                echo "$plainPassword" | sudo passwd --stdin "$Usuario" &>/dev/null
                echo " - Contraseña actualizada en Linux"
                success=true
            else
                errorMessage="Usuario no existe en Linux"
            fi
            ;;
        "ELIMINAR")
            if id "$Usuario" &>/dev/null; then
                sudo userdel -r "$Usuario"
                echo " - Usuario eliminado en Linux"
            else
                echo " - Usuario no encontrado, se omite"
            fi
            success=true
            ;;
        "RENOMBRAR")
            # Ejemplo: buscar nuevo nombre en usuarios_sync
            NuevoNombre=$($MYSQL -e "SELECT nuevo_nombre FROM usuarios_sync WHERE username='$Usuario' ORDER BY id DESC LIMIT 1;")
            if id "$Usuario" &>/dev/null; then
                sudo usermod -l "$NuevoNombre" "$Usuario"
                sudo mv /home/$Usuario /home/$NuevoNombre
                echo " - Usuario $Usuario renombrado a $NuevoNombre"
                success=true
            else
                errorMessage="Usuario no existe para renombrar"
            fi
            ;;
        *)
            errorMessage="Operacion desconocida: $Operacion"
            ;;
    esac

    # Actualizar estado en usuarios_sync
    if [ "$success" = true ]; then
        $MYSQL -e "UPDATE usuarios_sync SET linux_estado='ok', linux_error=NULL, ultima_actualizacion=NOW() WHERE username='$Usuario';"
        $MYSQL -e "UPDATE pendientes_sync SET procesado=1 WHERE id=$ID;"
        echo " - BD actualizada"
    else
        $MYSQL -e "UPDATE usuarios_sync SET linux_estado='error', linux_error='$errorMessage', ultima_actualizacion=NOW() WHERE username='$Usuario';"
        echo " - Registrado error en BD: $errorMessage"
    fi

    echo "------------------------------------"

done <<< "$Acciones"

echo "Sincronizacion Linux finalizada."
echo "$(date) - Script ejecutado" >> /Sincronizar.log
