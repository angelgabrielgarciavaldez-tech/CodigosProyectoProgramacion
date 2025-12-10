import winrm
import curses
import sys

# ===== CONFIGURACIÓN =====
WIN_HOST = "192.168.2.1"
WIN_USER = "Administrador"
WIN_PASS = "Greenday56"
# ========================

def get_process_list():
    """Obtiene los 10 procesos más pesados por CPU"""
    session = winrm.Session(f'http://{WIN_HOST}:5985/wsman', auth=(WIN_USER, WIN_PASS))
    r = session.run_ps("""
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 `
| Format-Table Id,Name,CPU -HideTableHeaders
""")
    output = r.std_out.decode().strip().splitlines()
    processes = []
    for line in output:
        parts = line.split()
        if len(parts) >= 3:
            pid = parts[0]
            name = parts[1]
            cpu = parts[2]
            processes.append(f"{pid} {name} CPU:{cpu}")
    return processes

def kill_process(pid_or_name):
    """Mata proceso por PID o nombre"""
    session = winrm.Session(f'http://{WIN_HOST}:5985/wsman', auth=(WIN_USER, WIN_PASS))
    if pid_or_name.isdigit():
        cmd = f"Stop-Process -Id {pid_or_name} -Force"
    else:
        cmd = f"Get-Process -Name {pid_or_name} | Stop-Process -Force"
    r = session.run_ps(cmd)
    if r.std_err:
        return "⚠️ No se pudo eliminar"
    return "✔ Proceso eliminado"

def menu(stdscr):
    curses.curs_set(0)
    while True:
        stdscr.clear()
        stdscr.addstr(0, 0, f"Conectado a: {WIN_HOST} | Selecciona proceso para eliminar (q para salir):")
        processes = get_process_list()
        for idx, proc in enumerate(processes):
            stdscr.addstr(idx+2, 2, f"{idx+1}. {proc}")
        stdscr.refresh()

        # Leer selección del usuario
        key = stdscr.getkey()
        if key.lower() == 'q':
            break
        if key.isdigit() and 1 <= int(key) <= len(processes):
            selection = processes[int(key)-1]
            pid = selection.split()[0]
            result = kill_process(pid)
            stdscr.addstr(len(processes)+3, 2, f"{result} - Presiona cualquier tecla para continuar")
            stdscr.refresh()
            stdscr.getkey()

if __name__ == "__main__":
    curses.wrapper(menu)
