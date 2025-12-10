$LinuxUser = "angelg"
$LinuxHost = "192.168.2.2"
$SSHKeyPath = "$env:USERPROFILE\.ssh\id_rsa"  # Llave privada de Windows

Write-Host "===== DISCOS Y PARTICIONES EN LINUX ($LinuxHost) ====="
ssh -i $SSHKeyPath "$LinuxUser@$LinuxHost" "lsblk -o NAME,SIZE,TYPE,MOUNTPOINT; df -h --total"
