# ----------------------------
# Configuración
# ----------------------------
$MySQLPath = "C:\ProgramData\chocolatey\bin\mysql.exe"
$DBHost    = "127.0.0.1"
$DBUser    = "ProyectoW"
$DBPass    = "123456789"
$DBName    = "Proyecto"
$LocalDir  = "C:\Descargas"

function Write-Log { param([string]$Message,[string]$Type="INFO"); $timestamp=Get-Date -Format "yyyy-MM-dd HH:mm:ss"; Write-Host "[$timestamp] [$Type] $Message" }

# ----------------------------
# Conexión MySQL segura
# ----------------------------
$tempFile="$env:TEMP\mysql.cnf"
@"
[client]
user=$DBUser
password=$DBPass
host=$DBHost
database=$DBName
"@ | Out-File -Encoding ASCII $tempFile

try {
    & $MySQLPath --defaults-extra-file=$tempFile -e "SELECT 1;" 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "No se pudo conectar a MySQL" }
    Write-Log "Conexion MySQL exitosa" -Type "SUCCESS"
} catch { Write-Log $_ -Type "ERROR"; exit 1 }

# ----------------------------
# Preguntar ID de usuario y validar
# ----------------------------
do {
    $UsuarioID = Read-Host "Ingresa tu ID de usuario"
    $existe = & $MySQLPath --defaults-extra-file=$tempFile -sN -e "SELECT COUNT(*) FROM usuarios_sync WHERE id=$UsuarioID;"
    if ($existe -eq 0) { Write-Log "Usuario no existe en la base de datos" -Type "ERROR" }
} while ($existe -eq 0)

# ----------------------------
# Consultar archivos compartidos con este usuario
# ----------------------------
$archivos = & $MySQLPath --defaults-extra-file=$tempFile -sN -e "SELECT ruta_archivo FROM archivos_compartidos WHERE contacto_id=$UsuarioID;"

if (-Not $archivos) {
    Write-Log "No tienes archivos compartidos" -Type "INFO"
    Remove-Item $tempFile -ErrorAction SilentlyContinue
    exit 0
}

# ----------------------------
# Crear carpeta local si no existe
# ----------------------------
if (-Not (Test-Path $LocalDir)) { New-Item -ItemType Directory -Path $LocalDir }

# ----------------------------
# Copiar archivos
# ----------------------------
foreach ($archivo in $archivos) {
    $dest = Join-Path $LocalDir (Split-Path $archivo -Leaf)
    if (Test-Path $archivo) {
        Copy-Item $archivo $dest -Force
        Write-Log "Archivo '$(Split-Path $archivo -Leaf)' descargado en $LocalDir" -Type "SUCCESS"
    } else {
        Write-Log "Archivo '$archivo' no encontrado en el servidor" -Type "ERROR"
    }
}

Remove-Item $tempFile -ErrorAction SilentlyContinue
Write-Log "Descarga completada" -Type "SUCCESS"
