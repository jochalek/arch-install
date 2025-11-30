#!/bin/bash
# Arch Linux Unified Installation Orchestrator
# For Chicago, USA timezone with Zen kernel
# This script manages the entire installation process across multiple phases

set -e

STATE_FILE="/tmp/arch-install-state"
INSTALL_DIR="/root/arch-install"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== Arch Linux Unified Installer ==="
echo ""

# Function to get current phase
get_phase() {
    if [ -f "${STATE_FILE}" ]; then
        cat "${STATE_FILE}"
    elif [ -f "${INSTALL_DIR}/.install-state" ]; then
        cat "${INSTALL_DIR}/.install-state"
    else
        echo "PHASE1"
    fi
}

# Function to set phase
set_phase() {
    local phase="$1"
    echo "${phase}" > "${STATE_FILE}"
    # Also save to install dir if it exists
    if [ -d "${INSTALL_DIR}" ]; then
        echo "${phase}" > "${INSTALL_DIR}/.install-state"
    fi
}

# Function to copy scripts to installed system
copy_to_installed_system() {
    echo "=== Copying installation scripts to installed system ==="
    mkdir -p /mnt/root/arch-install
    cp "${SCRIPT_DIR}"/*.sh /mnt/root/arch-install/
    chmod +x /mnt/root/arch-install/*.sh
    echo "${CURRENT_PHASE}" > /mnt/root/arch-install/.install-state
    echo "Scripts copied to /root/arch-install/"
}

# Detect current phase
CURRENT_PHASE=$(get_phase)

echo -e "${GREEN}Current Phase: ${CURRENT_PHASE}${NC}"
echo ""

case "${CURRENT_PHASE}" in
    PHASE1)
        echo "=== PHASE 1: Live ISO Installation ==="
        echo "This will run scripts 01-05 to set up disk, base system, and bootloader"
        echo ""
        
        # Run Phase 1 scripts
        bash "${SCRIPT_DIR}/01-disk-preparation.sh"
        echo ""
        
        bash "${SCRIPT_DIR}/02-base-install.sh"
        echo ""
        
        bash "${SCRIPT_DIR}/03-user-setup.sh"
        echo ""
        
        bash "${SCRIPT_DIR}/04-kernel-setup.sh"
        echo ""
        
        bash "${SCRIPT_DIR}/05-bootloader.sh"
        echo ""
        
        # Copy scripts to installed system
        copy_to_installed_system
        
        # Set next phase
        set_phase "PHASE2"
        
        echo ""
        echo -e "${YELLOW}=== PHASE 1 COMPLETE ===${NC}"
        echo ""
        echo -e "${GREEN}NEXT STEPS:${NC}"
        echo "1. Run: sync"
        echo "2. Run: systemctl reboot --firmware-setup"
        echo "3. In your UEFI/BIOS settings:"
        echo "   - Enable Secure Boot 'Setup Mode' (this clears existing keys)"
        echo "   - Save and exit"
        echo "4. Boot into your new Arch system"
        echo "5. Log in with the user account you created"
        echo "6. Run: cd ~/arch-install && sudo ./install.sh"
        echo ""
        read -p "Press Enter to acknowledge..."
        ;;
        
    PHASE2)
        echo "=== PHASE 2: Secure Boot Configuration ==="
        echo "This will run script 06 to set up Secure Boot"
        echo ""
        
        # Check if we're in the installed system (not live ISO)
        if [ ! -d "/efi" ]; then
            echo -e "${RED}ERROR: /efi directory not found!${NC}"
            echo "Make sure you've rebooted into the installed system"
            exit 1
        fi
        
        # Update script directory if running from installed location
        if [ -d "${INSTALL_DIR}" ]; then
            SCRIPT_DIR="${INSTALL_DIR}"
        fi
        
        # Run Phase 2 script
        bash "${SCRIPT_DIR}/06-secure-boot.sh"
        echo ""
        
        # Set next phase
        set_phase "PHASE3"
        
        echo ""
        echo -e "${YELLOW}=== PHASE 2 COMPLETE ===${NC}"
        echo ""
        echo -e "${GREEN}NEXT STEPS:${NC}"
        echo "1. Run: sudo reboot"
        echo "2. After reboot, log back in"
        echo "3. Run: cd ~/arch-install && sudo ./install.sh"
        echo ""
        read -p "Press Enter to acknowledge..."
        ;;
        
    PHASE3)
        echo "=== PHASE 3: TPM2 Configuration ==="
        echo "This will run script 07 to set up TPM2 automatic unlocking"
        echo ""
        
        # Update script directory if running from installed location
        if [ -d "${INSTALL_DIR}" ]; then
            SCRIPT_DIR="${INSTALL_DIR}"
        fi
        
        # Run Phase 3 script
        bash "${SCRIPT_DIR}/07-tpm2-setup.sh"
        echo ""
        
        # Set completion
        set_phase "COMPLETE"
        
        echo ""
        echo -e "${GREEN}=== INSTALLATION COMPLETE ===${NC}"
        echo ""
        echo "Your Arch Linux system is fully configured with:"
        echo "  ✓ Encrypted root partition (LUKS2)"
        echo "  ✓ Btrfs filesystem with subvolumes"
        echo "  ✓ Secure Boot with custom keys"
        echo "  ✓ TPM2 automatic unlocking"
        echo "  ✓ Unified Kernel Images"
        echo "  ✓ Zen kernel"
        echo ""
        echo -e "${YELLOW}FINAL STEP:${NC}"
        echo "1. Run: sudo reboot"
        echo "2. Test that TPM2 unlocking works"
        echo "3. Install your desktop environment (e.g., GNOME, KDE)"
        echo ""
        echo "Example for GNOME:"
        echo "  sudo pacman -S gnome gnome-extra"
        echo "  sudo systemctl enable gdm"
        echo "  sudo reboot"
        echo ""
        read -p "Press Enter to finish..."
        ;;
        
    COMPLETE)
        echo -e "${GREEN}=== Installation Already Complete ===${NC}"
        echo ""
        echo "Your Arch Linux system is fully installed!"
        echo "You can now install additional software and configure your desktop."
        echo ""
        echo "To reset and start over, delete: ${STATE_FILE}"
        if [ -f "${INSTALL_DIR}/.install-state" ]; then
            echo "And delete: ${INSTALL_DIR}/.install-state"
        fi
        ;;
        
    *)
        echo -e "${RED}ERROR: Unknown phase: ${CURRENT_PHASE}${NC}"
        echo "Delete state file to restart: ${STATE_FILE}"
        exit 1
        ;;
esac
