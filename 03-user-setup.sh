#!/bin/bash
# Part 3: User Creation for Arch Linux
# For Chicago, USA timezone with Zen kernel

set -e

echo "=== Arch Linux Installation - Part 3: User Setup ==="
echo ""

# Prompt for username
read -p "Enter username for your account: " USERNAME

echo ""
echo "=== Creating user account: ${USERNAME} ==="
arch-chroot /mnt useradd -G wheel -m "${USERNAME}"

echo ""
echo "Set password for ${USERNAME}:"
arch-chroot /mnt passwd "${USERNAME}"

echo ""
echo "=== Configuring sudo privileges for wheel group ==="
sed -i -e '/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^# //' /mnt/etc/sudoers

echo ""
echo "=== Part 3 Complete ==="
echo "User ${USERNAME} created with sudo privileges!"
echo ""
echo "Run 04-kernel-setup.sh next"
