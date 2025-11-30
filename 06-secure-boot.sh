#!/bin/bash
# Part 6: Secure Boot and TPM2 Setup for Arch Linux
# For Chicago, USA timezone with Zen kernel
# Run this AFTER rebooting into the installed system

set -e

echo "=== Arch Linux Installation - Part 6: Secure Boot & TPM2 ==="
echo ""

echo "=== Checking Secure Boot status ==="
sbctl status

echo ""
read -p "Is Setup Mode enabled? (yes/no): " SETUP_MODE

if [ "$SETUP_MODE" != "yes" ]; then
    echo "ERROR: Secure Boot must be in Setup Mode!"
    echo "Reboot and enable Setup Mode in your UEFI/BIOS settings"
    exit 1
fi

echo ""
echo "=== Creating and enrolling Secure Boot keys ==="
sudo sbctl create-keys
echo ""
echo "Enrolling keys with Microsoft vendor key (-m flag)"
echo "This is usually necessary for hardware compatibility"
sudo sbctl enroll-keys -m

echo ""
echo "=== Signing EFI binaries ==="
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
sudo sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign -s /efi/EFI/Linux/arch-linux-zen.efi
sudo sbctl sign -s /efi/EFI/Linux/arch-linux-zen-fallback.efi

echo ""
echo "=== Reinstalling kernel to trigger signing ==="
sudo pacman -S --noconfirm linux-zen

echo ""
echo "=== Part 6a Complete ==="
echo "Secure Boot keys created and EFI binaries signed!"
echo ""
echo "IMPORTANT: Reboot now to save Secure Boot settings"
echo "After reboot, run 07-tpm2-setup.sh to configure TPM2 unlocking"
echo ""
read -p "Press Enter to acknowledge..."
