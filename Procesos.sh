import winrm
import getpass
import sys
import time

WIN_HOST = "192.168.2.1"
WIN_USER = "Administrador"

def connect():
    global session
    print("==== Conectando al servidor Windows... ====")
    WIN_PASS = getpass.getpass("Contraseña del Administrador: ")
    session = winrm.Session(f'http://{WIN_HOST}:5985/wsman', auth=(WIN_USER, WIN_PASS))
    try:
        # Prueba de conexión simple
        result = session.run_ps("hostname")
        if result.std_out:
            print(f"\nConectado a: {result.std_out.decode().strip()}\n")
        else:
            raise Exception()
    except:
        print("❌ Error de autenticación o WinRM no habilitado en Windows.")
        sys.exit(1)

def show_processes():
    print("\n== Procesos más pesados por CPU ==\n")
    ps_cmd = """
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 `
    | Format-Table Id,Name,CPU -AutoSize
    """
    result = session.run_ps(ps_cmd)
    print(result.std_out.decode())

def kill_process(proceso):
    if proceso.isdigit():
        cmd = f"Stop-Process -Id {proceso} -Force"
    else:
        cmd = f"Get-Process -Name {proceso} | Stop-Process -Force"
    
    result = session.run_ps(cmd)
    
    if result.std_err:
        print("⚠️ No se pudo eliminar (ID o nombre incorrecto)")
    else:
        print("✔ Proceso eliminado si existía.")

def main():
    connect()
    while True:
        show_processes()
        proceso = input("\nPID o Nombre del proceso a matar ('salir' para terminar): ").strip()
        
        if proceso.lower() == "salir":
            print("👋 Finalizando conexión...")
            break
        
        kill_process(proceso)
        time.sleep(1)

if __name__ == "__main__":
    main()
