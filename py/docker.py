import subprocess, os

def handle_error():
    print(Back.RED + " ✘ An error occurred during execution. ")
    exit(1)

def install_packages():
    print(Back.BLUE + " ❍ Installing packages. ")
    process = subprocess.Popen(['sudo', 'apt', 'update', "&&", "sudo", "apt", "install", "ca-certificates", "curl", "gnupg", "-y"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    with alive_bar() as bar:
        for line in iter(process.stdout.readline, b''):
            line = line.decode('utf-8').strip()
            if line:
                print(line) 
                bar()

def download_gpg():
    print(Back.BLUE + " ❍ Downloading GPG. ")
    process = subprocess.Popen(["sudo", "install", "-m", "0755", "-d", "/etc/apt/keyrings", "&&", "curl", "-fsSL", "https://download.docker.com/linux/ubuntu/gpg", "&&", "sudo", "gpg", "--dearmor", "-o", "/etc/apt/keyrings/docker.gpg", "&&", "sudo", "chmod", "a+r", "/etc/apt/keyrings/docker.gpg"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    with alive_bar() as bar:
        for line in iter(process.stdout.readline, b''):
            line = line.decode('utf-8').strip()
            if line:
                print(line) 
                bar()

def add_docker_to_apt():
    print(Back.BLUE + " ❍ Adding Docker to APT. ")
    code = '''\
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME")    stable" | sudo tee /etc/apt/sources.list.d/docker.list
    '''
    process = subprocess.Popen([code, "&&", 'sudo', 'apt', 'update'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    with alive_bar() as bar:
        for line in iter(process.stdout.readline, b''):
            line = line.decode('utf-8').strip()
            if line:
                print(line) 
                bar()

def install_docker():
    print(Back.MAGENTA + " Installing Docker packages. ")
    process = subprocess.Popen(["sudo", "apt-get", "update", "&&", "sudo", "apt-get", "install", "docker-ce", "docker-ce-cli", "containerd.io", "docker-buildx-plugin", "docker-compose-plugin", "docker-compose", "-y"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    with alive_bar() as bar:
        for line in iter(process.stdout.readline, b''):
            line = line.decode('utf-8').strip()
            if line:
                print(line) 
                bar()


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
        from alive_progress import alive_bar
    except ModuleNotFoundError:
        subprocess.run(["pip", "install", "alive_progress"])
        print(Back.GREEN +" ✔ Progress bar installed. ")
        from alive_progress import alive_bar

    try:
        from colorama import init, Back
    except ModuleNotFoundError:
        subprocess.run(["pip", "install", "colorama"])
        print(Back.GREEN +" ✔ Colorama installed. ")
        from colorama import init, Back

    init(autoreset=True)

    try:
        install_packages()
        download_gpg()
        add_docker_to_apt()
        install_docker()
        print(Back.GREEN + " ✔ Docker is successfully installed. ")
    except Exception as e:
        handle_error()
