# ----------------------------
# Menú principal de administración
# ----------------------------
function Write-Log { param([string]$Message,[string]$Type="INFO"); $timestamp=Get-Date -Format "yyyy-MM-dd HH:mm:ss"; Write-Host "[$timestamp] [$Type] $Message" }

do {
    Clear-Host
    Write-Host "======================================="
    Write-Host "      MENU ADMINISTRACION WINDOWS      "
    Write-Host "======================================="
    Write-Host "1. Crear Usuario"
    Write-Host "2. Eliminar Usuario"
    Write-Host "3. Ver procesos"
    Write-Host "4. Agregar contacto"
    Write-Host "5. Subir archivo"
    Write-Host "6. Descargar archivo"
    Write-Host "7. Salir"
    Write-Host "======================================="
    $opcion = Read-Host "Selecciona una opcion (1-7)"

    switch ($opcion) {
        1 { 
            $user = Read-Host "Ingresa el nombre del usuario a crear"
            .\CrearUsuario.ps1 -Username $user
            Read-Host "Presiona Enter para continuar"
        }
        2 { 
            $user = Read-Host "Ingresa el nombre del usuario a eliminar"
            .\EliminarUsuario.ps1 -Username $user
            Read-Host "Presiona Enter para continuar"
        }
        3 { 
            .\Procesos.ps1
            Read-Host "Presiona Enter para continuar"
        }
        4 {
            .\AgregarContacto.ps1
            Read-Host "Presiona Enter para continuar"
        }
        5 {
            .\SubirArchivo.ps1
            Read-Host "Presiona Enter para continuar"
        }
        6 {
            .\DescargarArchivo.ps1
            Read-Host "Presiona Enter para continuar"
        }
        7 { Write-Host "Saliendo..."; break }
        default { Write-Host "Opcion invalida, intenta de nuevo"; Start-Sleep -Seconds 1 }
    }
} while ($true)
