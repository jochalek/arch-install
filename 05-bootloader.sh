#!/bin/bash
# Part 5: Services and Bootloader Setup for Arch Linux
# For Chicago, USA timezone with Zen kernel

set -e

echo "=== Arch Linux Installation - Part 5: Services & Bootloader ==="
echo ""

echo "=== Enabling system services ==="
systemctl --root /mnt enable systemd-resolved systemd-timesyncd NetworkManager
systemctl --root /mnt mask systemd-networkd

echo ""
echo "=== Installing systemd-boot bootloader ==="
arch-chroot /mnt bootctl install --esp-path=/efi

echo ""
echo "=== Part 5 Complete ==="
echo "Services enabled and bootloader installed!"
echo ""
echo "IMPORTANT NEXT STEPS:"
echo "1. Sync and reboot: run 'sync && systemctl reboot --firmware-setup'"
echo "2. In your UEFI/BIOS, put Secure Boot into 'Setup Mode'"
echo "3. Boot back into the installed system"
echo "4. Run 06-secure-boot.sh to configure Secure Boot and TPM2"
echo ""
read -p "Press Enter to acknowledge and continue..."
