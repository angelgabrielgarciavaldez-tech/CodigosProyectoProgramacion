# ----------------------------
# Configuración de MySQL y rutas
# ----------------------------
$MySQLPath = "C:\ProgramData\chocolatey\bin\mysql.exe"
$DBHost    = "127.0.0.1"
$DBUser    = "ProyectoW"
$DBPass    = "123456789"
$DBName    = "Proyecto"
$RemoteDir = "C:\ArchivosCompartidos"

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

do {
    $ContactoID = Read-Host "Ingresa el ID del contacto a quien compartir"
    $existe = & $MySQLPath --defaults-extra-file=$tempFile -sN -e "SELECT COUNT(*) FROM usuarios_sync WHERE id=$ContactoID;"
    if ($existe -eq 0) { Write-Log "Contacto no existe en la base de datos" -Type "ERROR" }
} while ($existe -eq 0)

# ----------------------------
# Solicitar ruta del archivo
# ----------------------------
$Archivo = Read-Host "Ingresa la ruta completa del archivo a subir"
if (-Not (Test-Path $Archivo)) { Write-Log "Archivo no existe" -Type "ERROR"; exit 1 }

# ----------------------------
# Crear carpeta remota si no existe
# ----------------------------
if (-Not (Test-Path $RemoteDir)) { New-Item -ItemType Directory -Path $RemoteDir }

$Destino = Join-Path $RemoteDir (Split-Path $Archivo -Leaf)
Copy-Item $Archivo $Destino -Force
Write-Log "Archivo '$($Archivo | Split-Path -Leaf)' copiado a $RemoteDir" -Type "SUCCESS"

# ----------------------------
# Registrar en base de datos
# ----------------------------
$query = @"
INSERT INTO archivos_compartidos (usuario_id, contacto_id, ruta_archivo, cifrado)
VALUES ($UsuarioID,$ContactoID,'$Destino',0)
ON DUPLICATE KEY UPDATE fecha=NOW();
"@

& $MySQLPath --defaults-extra-file=$tempFile -e "$query"

Remove-Item $tempFile -ErrorAction SilentlyContinue
Write-Log "Archivo compartido exitosamente con el contacto $ContactoID" -Type "SUCCESS"
