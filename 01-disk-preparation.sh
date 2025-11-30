#!/bin/bash
# Part 1: Disk Preparation for Arch Linux with Secure Boot
# For Chicago, USA timezone with Zen kernel

set -e

echo "=== Arch Linux Installation - Part 1: Disk Preparation ==="
echo "This script will prepare your disk for installation"
echo ""

# Find and display available disks
echo "Available disks:"
lsblk -d -o NAME,SIZE,TYPE | grep disk
echo ""

# Prompt for disk selection
read -p "Enter the disk to use (e.g., sda, nvme0n1, vda): " DISK
DISK="/dev/${DISK}"

# Confirm disk selection
echo ""
echo "WARNING: This will ERASE ALL DATA on ${DISK}"
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Installation cancelled."
    exit 1
fi

echo ""
echo "=== Setting up partitions on ${DISK} ==="

# Clear partition table and create new partitions
sgdisk -Z "${DISK}"
sgdisk -n1:0:+512M -t1:ef00 -c1:EFI -N2 -t2:8304 -c2:LINUXROOT "${DISK}"
partprobe -s "${DISK}"

echo ""
echo "Partitions created:"
lsblk "${DISK}"

# Determine partition naming scheme
if [[ "${DISK}" == *"nvme"* ]] || [[ "${DISK}" == *"mmcblk"* ]]; then
    PART1="${DISK}p1"
    PART2="${DISK}p2"
else
    PART1="${DISK}1"
    PART2="${DISK}2"
fi

echo ""
echo "=== Encrypting root partition with LUKS ==="
cryptsetup luksFormat --type luks2 "${PART2}"
echo ""
echo "Enter the passphrase again to open the encrypted partition:"
cryptsetup luksOpen "${PART2}" linuxroot

echo ""
echo "=== Creating filesystems ==="
mkfs.vfat -F32 -n EFI "${PART1}"
mkfs.btrfs -f -L linuxroot /dev/mapper/linuxroot

echo ""
echo "=== Mounting partitions and creating btrfs subvolumes ==="
mount /dev/mapper/linuxroot /mnt
mkdir /mnt/efi
mount "${PART1}" /mnt/efi

# Create btrfs subvolume for home only
btrfs subvolume create /mnt/home

echo ""
echo "=== Part 1 Complete ==="
echo "Disk preparation finished successfully!"
echo "Partitions are mounted and ready for base installation."
echo ""
echo "Run 02-base-install.sh next"
