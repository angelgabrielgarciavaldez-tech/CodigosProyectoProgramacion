param(
    [Parameter(Mandatory=$true)][string]$Username,
    [Parameter(Mandatory=$true)][string]$Password,
    [string]$MySQLPath = "C:\ProgramData\chocolatey\bin\mysql.exe",
    [string]$DBHost = "127.0.0.1",
    [string]$DBUser = "ProyectoW",
    [string]$DBPass = "123456789",
    [string]$DBName = "Proyecto"
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

function New-SSHKeys { 
    param([string]$Username)
    $sshFolder="C:\Users\$Username\.ssh"
    $privateKey=Join-Path $sshFolder "id_rsa"
    $publicKey=Join-Path $sshFolder "id_rsa.pub"
    if (!(Test-Path $sshFolder)) { New-Item -ItemType Directory -Path $sshFolder -Force | Out-Null }
    ssh-keygen.exe -t rsa -b 2048 -q -N "" -f $privateKey -y 2>$null | Out-Null
    if (Test-Path $publicKey) { return (Get-Content $publicKey -Raw).Trim() } else { return "" }
}

function Register-InDatabase {
    param([string]$Username,[string]$PasswordHash,[string]$PublicKey)
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
INSERT INTO usuarios_sync (username, password_hash, ssh_key_pub, creado_en, linux_estado, windows_estado, fecha_creado)
VALUES ('$Username','$PasswordHash','$PublicKey','windows','pendiente','ok',NOW())
ON DUPLICATE KEY UPDATE password_hash='$PasswordHash', ssh_key_pub='$PublicKey', windows_estado='ok', ultima_actualizacion=NOW();
"@
        & $MySQLPath --defaults-extra-file=$tempFile -e "$query1" 2>$null | Out-Null

        $idUsuario=& $MySQLPath --defaults-extra-file=$tempFile -sN -e "SELECT id FROM usuarios_sync WHERE username='$Username' LIMIT 1;"

        $query2=@"
INSERT INTO logs_sync (id_usuario_sync, evento, sistema, mensaje, fecha)
VALUES ($idUsuario, 'CREADO', 'windows', 'Usuario Windows creado y llaves SSH generadas', NOW());
"@
        & $MySQLPath --defaults-extra-file=$tempFile -e "$query2" 2>$null | Out-Null

        $query3=@"
INSERT INTO pendientes_sync (username, accion, destino, fecha)
VALUES ('$Username','CREAR','LINUX',NOW())
ON DUPLICATE KEY UPDATE accion='CREAR', fecha=NOW();
"@
        & $MySQLPath --defaults-extra-file=$tempFile -e "$query3" 2>$null | Out-Null

        Remove-Item $tempFile -ErrorAction SilentlyContinue
        return $true
    } catch { return $false }
}

# ----- PROGRAMA -----
try {
    Write-Host "===== INICIANDO CREACION DE USUARIO ====="

    if (Test-MySQLConnection) { Write-Log "Conexion MySQL exitosa" -Type "SUCCESS" }
    else { Write-Log "No se pudo conectar a MySQL" -Type "ERROR"; exit 1 }

    $winUser=Get-LocalUser -Name $Username -ErrorAction SilentlyContinue
    if (-not $winUser) {
        $securePassword=ConvertTo-SecureString $Password -AsPlainText -Force
        New-LocalUser -Name $Username -Password $securePassword -Description "Usuario sincronizado" -AccountNeverExpires
        Add-LocalGroupMember -Group "Usuarios" -Member $Username
        Write-Log "Usuario Windows creado" -Type "SUCCESS"
    } else { Write-Log "Usuario Windows ya existe" -Type "INFO" }

    Write-Log "Generando llaves SSH..."
    $publicKey=New-SSHKeys -Username $Username
    Write-Log "Llaves SSH generadas" -Type "SUCCESS"

    if (Register-InDatabase -Username $Username -PasswordHash $Password -PublicKey $publicKey) { Write-Log "Usuario registrado en BD" -Type "SUCCESS" }
    else { Write-Log "Error registrando usuario en BD" -Type "ERROR" }

    Write-Host "`n===== RESUMEN FINAL ====="
    Write-Host "Usuario Windows: COMPLETADO"
    Write-Host "Llaves SSH: COMPLETADO"
    Write-Host "Base de Datos: COMPLETADO"
    Write-Host "`nCarpeta SSH: C:\Users\$Username\.ssh"
    Write-Host "Llave publica:`n$publicKey"

} catch { Write-Log "Error: $($_.Exception.Message)" -Type "ERROR" }
