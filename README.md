# Arch Linux Installation Scripts
## Secure Boot, btrfs, TPM2 LUKS Encryption, Unified Kernel Images (Zen Kernel)

Adapted for **Chicago, USA** timezone with the **Zen kernel**.

---

## Prerequisites

1. Boot from the latest Arch Linux ISO
2. Verify internet connectivity: `ping archlinux.org`
3. If using WiFi: `iwctl` to connect
4. Download these scripts or copy them to the live environment

---

## Installation Steps

### Phase 1: From Arch Live ISO

Run these scripts **in order** while booted from the Arch ISO:

```bash
# 1. Prepare disk partitions and encryption
chmod +x 01-disk-preparation.sh
./01-disk-preparation.sh

# 2. Install base system (USA mirrors, Zen kernel)
chmod +x 02-base-install.sh
./02-base-install.sh

# 3. Create your user account
chmod +x 03-user-setup.sh
./03-user-setup.sh

# 4. Configure Unified Kernel Images
chmod +x 04-kernel-setup.sh
./04-kernel-setup.sh

# 5. Install bootloader and enable services
chmod +x 05-bootloader.sh
./05-bootloader.sh
```

After script 5 completes:
```bash
sync
systemctl reboot --firmware-setup
```

---

### Phase 2: UEFI/BIOS Configuration

1. In your UEFI/BIOS settings, enable **"Setup Mode"** for Secure Boot
   - This clears existing keys
   - Check your motherboard manual for exact steps
2. Save and exit
3. Boot into your newly installed Arch system

---

### Phase 3: From Installed System

Log in with your created user account and run:

```bash
# 6. Configure Secure Boot
chmod +x 06-secure-boot.sh
./06-secure-boot.sh
```

After this script, **reboot** to save Secure Boot settings:
```bash
sudo reboot
```

---

### Phase 4: Final Configuration

Boot back into your system and run:

```bash
# 7. Configure TPM2 auto-unlocking
chmod +x 07-tpm2-setup.sh
./07-tpm2-setup.sh
```

**Final reboot** to test TPM unlocking:
```bash
sudo reboot
```

---

## What's Configured

- **Timezone**: America/Chicago
- **Locale**: en_US.UTF-8
- **Keyboard**: US layout
- **Kernel**: linux-zen (performance-focused kernel)
- **Microcode**: Both Intel and AMD (installed, correct one used automatically)
- **Encryption**: LUKS2 on root partition
- **Filesystem**: btrfs with /home subvolume
- **Boot**: Unified Kernel Images (UKI) with systemd-boot
- **Secure Boot**: Custom keys with Microsoft vendor key fallback
- **TPM2**: Automatic disk unlocking (optional PIN protection)

---

## Post-Installation

After completing all scripts, you can:

1. Install a desktop environment (GNOME, KDE, etc.)
2. Install additional software
3. Configure your system further

Example for GNOME:
```bash
sudo pacman -S gnome gnome-extra
sudo systemctl enable gdm
sudo reboot
```

---

## Important Notes

### Recovery Key
During script 7, you'll generate a recovery key. **SAVE THIS SAFELY!**
You'll need it if:
- TPM fails
- Hardware changes affect TPM state
- BIOS/firmware updates

### Microcode
Both Intel and AMD microcode are installed. The system automatically loads the correct one for your CPU.

### Zen Kernel
The Zen kernel is optimized for desktop performance. If you prefer the standard kernel, edit script 2 to use `linux` instead of `linux-zen`, and adjust script 4 and 6 accordingly.

### TPM PIN
During script 7, you can choose:
- **With PIN**: More secure, requires PIN on every boot
- **Without PIN**: Convenient, automatic unlock (still protected by TPM)

---

## Troubleshooting

**System won't boot after Secure Boot setup:**
- Disable Secure Boot in UEFI/BIOS temporarily
- Boot the Arch ISO
- Mount your system and re-run the signing commands

**TPM unlock fails:**
- Use your recovery key at the prompt
- Check TPM status: `systemd-cryptenroll --tpm2-device=list`
- Re-enroll: Run script 7 again

**Can't find scripts after reboot:**
- Scripts need to be on the installed system
- Copy them before first reboot or download again after installation

---

## Credits

Based on the guide by walian.co.uk, adapted for Chicago/USA with Zen kernel.

---

## License

These scripts are provided as-is. Use at your own risk. Always backup important data before installation.
