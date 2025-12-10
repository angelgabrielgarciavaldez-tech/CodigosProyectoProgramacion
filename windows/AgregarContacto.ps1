param()

# ===== CONFIGURACION =====
$MySQLPath = "C:\ProgramData\chocolatey\bin\mysql.exe"
$DBHost    = "127.0.0.1"
$DBUser    = "ProyectoW"
$DBPass    = "123456789"
$DBName    = "Proyecto"

# ===== FUNCIONES =====
function Write-Log { 
    param([string]$Message, [string]$Type="INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Type] $Message"
}

function Test-MySQLConnection {
    try {
        $tempFile = "$env:TEMP\mysql.cnf"
        @"
[client]
user=$DBUser
password=$DBPass
host=$DBHost
database=$DBName
"@ | Out-File -Encoding ASCII $tempFile
        & $MySQLPath --defaults-extra-file=$tempFile -e "SELECT 1;" 2>$null | Out-Null
        Remove-Item $tempFile -ErrorAction SilentlyContinue
        return ($LASTEXITCODE -eq 0)
    } catch { return $false }
}

function Get-Usuarios {
    $tempFile = "$env:TEMP\mysql.cnf"
    @"
[client]
user=$DBUser
password=$DBPass
host=$DBHost
database=$DBName
"@ | Out-File -Encoding ASCII $tempFile

    $query = "SELECT id, username FROM usuarios_sync ORDER BY id;"
    $raw = & $MySQLPath --defaults-extra-file=$tempFile -B -e $query | Select-Object -Skip 1
    Remove-Item $tempFile -ErrorAction SilentlyContinue

    $usuarios = @()
    foreach ($line in $raw) {
        $parts = $line -split "`t"
        $usuarios += [PSCustomObject]@{ ID = [int]$parts[0]; Username = $parts[1] }
    }
    return $usuarios
}

function Agregar-Contacto {
    param([int]$UsuarioID, [int]$ContactoID)

    $tempFile = "$env:TEMP\mysql.cnf"
    @"
[client]
user=$DBUser
password=$DBPass
host=$DBHost
database=$DBName
"@ | Out-File -Encoding ASCII $tempFile

    $query = @"
INSERT INTO contactos (usuario_id, contacto_id, agregado_en)
VALUES ($UsuarioID, $ContactoID, NOW())
ON DUPLICATE KEY UPDATE agregado_en=NOW();
"@
    & $MySQLPath --defaults-extra-file=$tempFile -e "$query" 2>$null | Out-Null
    Remove-Item $tempFile -ErrorAction SilentlyContinue
    Write-Log "Contacto agregado exitosamente: Usuario $UsuarioID -> Contacto $ContactoID" -Type "SUCCESS"
}

# ===== PROGRAMA PRINCIPAL =====
try {
    Write-Host "===== AGREGAR CONTACTO ====="

    if (Test-MySQLConnection) { Write-Log "Conexion MySQL exitosa" -Type "SUCCESS" }
    else { Write-Log "No se pudo conectar a MySQL. Abortando." -Type "ERROR"; exit 1 }

    $usuarios = Get-Usuarios
    if ($usuarios.Count -eq 0) { Write-Log "No hay usuarios en la base de datos" -Type "ERROR"; exit 1 }

    Write-Host "`nUsuarios disponibles:"
    $usuarios | ForEach-Object { Write-Host "$($_.ID)  $($_.Username)" }

    $UsuarioID = [int](Read-Host "`nIngresa el ID del usuario")
    $ContactoID = [int](Read-Host "Ingresa el ID del contacto a agregar")

    if (-not ($usuarios.ID -contains $UsuarioID)) { Write-Log "Usuario seleccionado no existe en la base de datos" -Type "ERROR"; exit 1 }
    if (-not ($usuarios.ID -contains $ContactoID)) { Write-Log "Contacto seleccionado no existe en la base de datos" -Type "ERROR"; exit 1 }

    Agregar-Contacto -UsuarioID $UsuarioID -ContactoID $ContactoID

    Write-Host "`n===== FIN ====="

} catch {
    Write-Log "Error: $($_.Exception.Message)" -Type "ERROR"
}
