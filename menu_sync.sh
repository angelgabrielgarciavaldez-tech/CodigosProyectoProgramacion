#!/bin/bash

# Ruta donde estarán tus Scripts
SCRIPTS_DIR="/root"

# Asegurar que dialog esté instalado
command -v dialog >/dev/null 2>&1 || { 
    echo "Instalando dialog..."
    sudo apt-get install -y dialog
}

# Funciones
crear_usuario() {
    bash "$SCRIPTS_DIR/agregar_usuarioDialog.sh"
}

eliminar_usuario() {
    bash "$SCRIPTS_DIR/eliminar_usuarioDialog.sh"
}

ver_procesos() {
	bash "$SCRIPTS_DIR/Procesos.py"
}

agregar_contacto() {
    bash "$SCRIPTS_DIR/agregar_contacto.sh"
}

subir_archivo() {
    bash "$SCRIPTS_DIR/subir_archivo.sh"
}

bajar_archivo() {
    bash "$SCRIPTS_DIR/descargar_archivo.sh"
}

# Menú principal
while true; do
    OPCION=$(dialog --clear --stdout \
        --title "🔐 Sistema de Sincronización Linux ↔ Windows" \
        --menu "Selecciona una opción:" 20 70 10 \
        1 "Crear usuario" \
        2 "Eliminar usuario" \
        3 "Ver procesos" \
        4 "Agregar contacto" \
        5 "Subir archivo a contacto" \
        6 "Descargar archivo" \
        0 "Salir")

    case $OPCION in
        1) crear_usuario ;;
        2) eliminar_usuario ;;
        3) ver_procesos ;;
        4) agregar_contacto ;;
        5) subir_archivo ;;
        6) bajar_archivo ;;
        0) clear; exit 0 ;;
    esac
done
