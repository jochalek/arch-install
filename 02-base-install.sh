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
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode amd-ucode vim nano cryptsetup btrfs-progs dosfstools util-linux git unzip sbctl ghostty iwd impala sudo

echo ""
echo "=== Configuring locale settings for US ==="
# Set US English locale
sed -i -e "/^#en_US.UTF-8/s/^#//" /mnt/etc/locale.gen

echo ""
echo "=== Configuring system settings ==="
echo "Default settings: Keymap=us, Timezone=America/Chicago, Locale=en_US.UTF-8"
echo ""
read -p "Do you want to use different settings? (yes/no): " CUSTOM_SETTINGS

if [ "$CUSTOM_SETTINGS" = "yes" ]; then
    echo ""
    echo "Please configure your custom settings when prompted:"
    systemd-firstboot --root /mnt --prompt
else
    echo ""
    echo "Using default Chicago/USA settings..."
    echo "You will only be prompted for hostname."
    systemd-firstboot --root /mnt --keymap=us --timezone=America/Chicago --locale=en_US.UTF-8 --prompt-hostname
fi

# Generate locales
echo ""
echo "=== Generating locales ==="
arch-chroot /mnt locale-gen

echo ""
echo "=== Part 2 Complete ==="
echo "Base system installed successfully!"
echo ""
echo "Run 03-user-setup.sh next"
