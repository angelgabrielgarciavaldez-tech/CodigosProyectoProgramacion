param(
    [Parameter(Mandatory=$true)][string]$Username,
    [string]$MySQLPath="C:\ProgramData\chocolatey\bin\mysql.exe",
    [string]$DBHost="127.0.0.1",
    [string]$DBUser="ProyectoW",
    [string]$DBPass="123456789",
    [string]$DBName="Proyecto"
)

function Write-Log { param([string]$Message,[string]$Type="INFO"); $timestamp=Get-Date -Format "yyyy-MM-dd HH:mm:ss"; Write-Host "[$timestamp] [$Type] $Message" }

function Test-MySQLConnection {
    try {
        $tempFile="$env:TEMP\mysql.cnf"
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

function Remove-UserFromDatabase {
    param([string]$Username)
    $tempFile="$env:TEMP\mysql.cnf"
    @"
[client]
user=$DBUser
password=$DBPass
host=$DBHost
database=$DBName
"@ | Out-File -Encoding ASCII $tempFile
    try {
        $query1=@"
UPDATE usuarios_sync
SET windows_estado='eliminado', ultima_actualizacion=NOW()
WHERE username='$Username';
"@
        & $MySQLPath --defaults-extra-file=$tempFile -e "$query1" 2>$null | Out-Null

        $idUsuario=& $MySQLPath --defaults-extra-file=$tempFile -sN -e "SELECT id FROM usuarios_sync WHERE username='$Username' LIMIT 1;"
        if ($idUsuario) {
            $query2=@"
INSERT INTO logs_sync (id_usuario_sync, evento, sistema, mensaje, fecha)
VALUES ($idUsuario,'ELIMINADO','windows','Usuario Windows eliminado',NOW());
"@
            & $MySQLPath --defaults-extra-file=$tempFile -e "$query2" 2>$null | Out-Null
        }

        $query3=@"
DELETE FROM pendientes_sync WHERE username='$Username' AND destino='LINUX';
"@
        & $MySQLPath --defaults-extra-file=$tempFile -e "$query3" 2>$null | Out-Null

        Remove-Item $tempFile -ErrorAction SilentlyContinue
        return $true
    } catch { return $false }
}

# ----- PROGRAMA -----
try {
    Write-Host "===== INICIANDO ELIMINACION DE USUARIO ====="

    if (Test-MySQLConnection) { Write-Log "Conexion MySQL exitosa" -Type "SUCCESS" }
    else { Write-Log "No se pudo conectar a MySQL" -Type "ERROR"; exit 1 }

    $winUser=Get-LocalUser -Name $Username -ErrorAction SilentlyContinue
    if ($winUser) {
        Remove-LocalUser -Name $Username
        Write-Log "Usuario Windows eliminado" -Type "SUCCESS"

        $sshFolder="C:\Users\$Username\.ssh"
        if (Test-Path $sshFolder) { Remove-Item $sshFolder -Recurse -Force; Write-Log "Carpeta SSH eliminada" -Type "SUCCESS" }
    } else { Write-Log "Usuario Windows no existe" -Type "INFO" }

    if (Remove-UserFromDatabase -Username $Username) { Write-Log "Base de datos actualizada" -Type "SUCCESS" }
    else { Write-Log "Usuario no existía en la base de datos" -Type "INFO" }

    Write-Host "`n===== RESUMEN FINAL ====="
    Write-Host "Usuario Windows: ELIMINADO"
    Write-Host "SSH: ELIMINADO"
    Write-Host "Base de Datos: ACTUALIZADA"

} catch { Write-Log "Error: $($_.Exception.Message)" -Type "ERROR" }
