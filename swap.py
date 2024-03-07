import subprocess, shutil, os
from colorama import init, Back

init(autoreset=True)

def check_swap():
    if psutil.swap_memory().total > 0:
        print(Back.MAGENTA + " ✶ Swap file already exists. Exiting. ")
        exit(1)
    else:
        return True

def check_disk_space():
    stat = shutil.disk_usage('/')
    if (stat.free // (2**20)) <= 2048:
        print(Back.RED + " ✘ Not enough disk space to create swap file. Exiting. ")
        exit(2)
    return True

def create_swap():
    try:
        subprocess.run(["fallocate", "-l", "2048M", "/swapfile"], check=True)
        subprocess.run(["chmod", "600", "/swapfile"], check=True)
        subprocess.run(["mkswap", "/swapfile"], check=True)
        subprocess.run(["swapon", "/swapfile"], check=True)
        print(Back.GREEN + " ✔ Swap created and activated successfully. ")

    except subprocess.CalledProcessError as e:
        print(Back.RED + " ✘ Error creating swap file. Exiting. ")
        print(f"{e}")
        exit(3)

if __name__ == "__main__":
    if os.geteuid() != 0:
        print(Back.RED +" ✘ This script needs to be executed with administrator privileges (sudo). ")
        exit(4)
    try:
        import pip
    except ModuleNotFoundError:
        subprocess.run(["sudo", "apt", "update"])
        subprocess.run(["sudo", "apt", "install", "python3-pip", "-y"])
        print(Back.GREEN +" ✔ Pip installed. ")

    try:
        import psutil
    except ModuleNotFoundError:
        subprocess.run(["pip", "install", "psutil"])
        print(Back.GREEN +" ✔ Psutil installed. ")
        import psutil

    try:
        import colorama
    except ModuleNotFoundError:
        subprocess.run(["pip", "install", "colorama"])
        print(Back.GREEN +" ✔ Colorama installed. ")
        import colorama

    if check_swap():
        if check_disk_space():
            create_swap()
