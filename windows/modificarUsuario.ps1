param (
    [string]$Username
)

if (-not $Username) {
    Write-Host "Uso: .\modificarUsuario.ps1 -Username nombreUsuario"
    exit
}

Write-Host "=== Modificación de usuario Windows: $Username ==="
Write-Host "Selecciona qué quieres modificar:"
Write-Host "1) Contraseña"
Write-Host "2) Nombre de usuario"
Write-Host "3) Ambos"
$opcion = Read-Host "Opción"

if ($opcion -eq "1" -or $opcion -eq "3") {
    $pass = Read-Host "Nueva contraseña" -AsSecureString
}

if ($opcion -eq "2" -or $opcion -eq "3") {
    $nuevo = Read-Host "Nuevo nombre de usuario"
}

# Ejecutar cambios
try {
    if ($opcion -eq "1" -or $opcion -eq "3") {
        Set-LocalUser -Name $Username -Password $pass
        Write-Host "- Contraseña actualizada"
    }

    if ($opcion -eq "2" -or $opcion -eq "3") {
        Rename-LocalUser -Name $Username -NewName $nuevo
        Write-Host "- Usuario renombrado a $nuevo"
    }

    # Actualizar BD
    $passPlain = ""
    if ($opcion -eq "1" -or $opcion -eq "3") {
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)
        $passPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }

    $query = "UPDATE usuarios_sync SET username = IF($opcion IN ('2','3'),'$nuevo',username), password_hash = IF($opcion IN ('1','3'),'$([System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes('$passPlain')))).Replace('-','')',password_hash), windows_estado='ok', ultima_actualizacion=NOW() WHERE username='$Username';"
    
    & "C:\ProgramData\chocolatey\bin\mysql.exe" -h 192.168.2.1 -u ProyectoW -p123456789 Proyecto -e $query

    Write-Host "BD actualizada."
    Write-Host "Modificación Windows finalizada."

} catch {
    Write-Host "[ERROR] $_"
}
