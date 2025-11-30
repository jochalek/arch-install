#!/bin/bash
# Part 4: Unified Kernel Image Setup for Arch Linux
# For Chicago, USA timezone with Zen kernel

set -e

echo "=== Arch Linux Installation - Part 4: Kernel & UKI Setup ==="
echo ""

echo "=== Creating kernel cmdline file ==="
echo "quiet rw" > /mnt/etc/kernel/cmdline

echo ""
echo "=== Creating EFI folder structure ==="
mkdir -p /mnt/efi/EFI/Linux

echo ""
echo "=== Configuring mkinitcpio for systemd hooks ==="
cat > /mnt/etc/mkinitcpio.conf << 'EOF'
# vim:set ft=sh
MODULES=()
BINARIES=()
FILES=()
HOOKS=(base systemd autodetect modconf kms keyboard sd-vconsole sd-encrypt block filesystems fsck)
EOF

echo ""
echo "=== Configuring mkinitcpio preset for Zen kernel UKIs ==="
cat > /mnt/etc/mkinitcpio.d/linux-zen.preset << 'EOF'
# mkinitcpio preset file to generate UKIs for linux-zen
ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux-zen"
ALL_microcode=(/boot/*-ucode.img)

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux-zen.img"
default_uki="/efi/EFI/Linux/arch-linux-zen.efi"
default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-zen-fallback.img"
fallback_uki="/efi/EFI/Linux/arch-linux-zen-fallback.efi"
fallback_options="-S autodetect"
EOF

echo ""
echo "=== Generating Unified Kernel Images ==="
arch-chroot /mnt mkinitcpio -P

echo ""
echo "=== Verifying UKI files were created ==="
ls -lh /mnt/efi/EFI/Linux/

echo ""
echo "=== Part 4 Complete ==="
echo "Unified Kernel Images created successfully!"
echo ""
echo "Run 05-bootloader.sh next"
