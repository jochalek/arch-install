#!/bin/bash
# Part 2: Base Installation for Arch Linux
# For Chicago, USA timezone with Zen kernel

set -e

echo "=== Arch Linux Installation - Part 2: Base Installation ==="
echo ""

# Update pacman mirrors for USA
echo "=== Updating pacman mirrors for USA ==="
reflector --country US --age 24 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist

echo ""
echo "=== Installing base system with Zen kernel ==="
# Note: Installing zen kernel and zen kernel headers
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode amd-ucode vim nano cryptsetup btrfs-progs dosfstools util-linux git unzip sbctl kitty networkmanager sudo

echo ""
echo "=== Configuring locale settings for US ==="
# Set US English locale
sed -i -e "/^#en_US.UTF-8/s/^#//" /mnt/etc/locale.gen

echo ""
echo "=== Running systemd-firstboot ==="
echo "Please configure your system when prompted:"
echo "  - Keymap: us (for US keyboard)"
echo "  - Timezone: America/Chicago"
echo "  - Hostname: choose a name for your computer"
echo ""
read -p "Press Enter to continue..."

systemd-firstboot --root /mnt --prompt

# Generate locales
echo ""
echo "=== Generating locales ==="
arch-chroot /mnt locale-gen

echo ""
echo "=== Part 2 Complete ==="
echo "Base system installed successfully!"
echo ""
echo "Run 03-user-setup.sh next"
