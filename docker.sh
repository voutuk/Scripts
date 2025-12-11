#!/bin/bash
set -euo pipefail

# Colored output functions
info() { echo -e "\e[30;44m ❍ $1 \e[0m"; }
success() { echo -e "\e[42m\e[30m ✔ $1 \e[0m"; }
error() { echo -e "\e[30m\e[41m ✘ $1 \e[0m"; exit 1; }

# Check for root/sudo privileges
if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    if ! command -v sudo &>/dev/null; then
        error "sudo not found. Run script as root or install sudo."
    fi
    SUDO="sudo"
fi

# Detect distribution
if [[ ! -f /etc/os-release ]]; then
    error "Unable to detect system distribution."
fi

source /etc/os-release
OS_ID="${ID}"
OS_VERSION="${VERSION_CODENAME:-${VERSION_ID}}"

# Avoid interactive apt dialogs (e.g., tzdata prompts)
export DEBIAN_FRONTEND=noninteractive

# Support Ubuntu and Debian only
if [[ "$OS_ID" != "ubuntu" ]] && [[ "$OS_ID" != "debian" ]]; then
    error "Script supports only Ubuntu and Debian. Current system: $OS_ID"
fi

info "System: $OS_ID $OS_VERSION"

# Remove old Docker versions
info "Removing old Docker versions (if any)..."
$SUDO apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Update package list
info "Updating package list..."
$SUDO apt-get update -qq || error "Failed to update apt"

# Install required packages
info "Installing required packages..."
$SUDO apt-get install -y ca-certificates curl gnupg lsb-release || error "Failed to install packages"

# Add Docker GPG key
info "Adding Docker GPG key..."
$SUDO install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/$OS_ID/gpg" | $SUDO gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg || error "Failed to download GPG key"
$SUDO chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
info "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS_ID $OS_VERSION stable" | \
    $SUDO tee /etc/apt/sources.list.d/docker.list >/dev/null || error "Failed to add repository"

# Update after adding repository
info "Updating package list..."
$SUDO apt-get update -qq || error "Failed to update apt after adding repository"

# Install Docker
info "Installing Docker..."
$SUDO apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin || error "Failed to install Docker"

# Verify installation
info "Verifying installation..."
if ! command -v docker &>/dev/null; then
    error "Docker not installed correctly"
fi

DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | tr -d ',')
success "Docker $DOCKER_VERSION successfully installed!"

# Add current user to docker group
if [[ $EUID -ne 0 ]] && [[ -n "${SUDO_USER:-}" ]]; then
    info "Adding user $SUDO_USER to docker group..."
    $SUDO usermod -aG docker "$SUDO_USER"
    success "User $SUDO_USER added to docker group. Re-login to apply changes."
fi