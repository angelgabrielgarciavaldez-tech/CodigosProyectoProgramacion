#!/bin/bash

ENTRADA="/srv/archivos/entrada"
SALIDA="/srv/archivos/salida"

GPG_KEY="sync@gmail.com"

for FILE in "$ENTRADA"/*; do
    [ -e "$FILE" ] || continue

    EXT="${FILE##*.}"
    NOMBRE="$(basename "$FILE")"

    if [[ "$EXT" != "gpg" ]]; then
        echo "Archivo rechazado (NO cifrado): $NOMBRE"
        rm -f "$FILE"
        continue
    fi

    echo "Procesando archivo cifrado: $NOMBRE"

    # Descifrado
    if gpg --yes --output "$FILE.decrypted" --decrypt "$FILE"; then
        echo " OK: Archivo descifrado → Movido a salida"
        mv "$FILE.decrypted" "$SALIDA/${NOMBRE%.gpg}"
        rm -f "$FILE"
    else
        echo "ERROR: No se pudo descifrar → Rechazado"
        rm -f "$FILE"
    fi
done
