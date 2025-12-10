dd$LinuxHost = "192.168.2.2"
$LinuxUser = "root"

while ($true) {
    Write-Host "`n=== Procesos en Linux remoto ==="
    ssh $LinuxUser@$LinuxHost "ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head -20"

    $proceso = Read-Host "Escribe el PID o nombre del proceso a matar (o 'salir' para terminar)"
    if ($proceso -eq "salir") { break }

    if ($proceso -match '^\d+$') {
        ssh $LinuxUser@$LinuxHost "kill -9 $proceso"
    } else {
        ssh $LinuxUser@$LinuxHost "pkill -f $proceso"
    }

    Write-Host "Proceso eliminado si existía."
}
