# Arch Linux Installation Scripts
## Secure Boot, btrfs, TPM2 LUKS Encryption, Unified Kernel Images (Zen Kernel)

Adapted for **Chicago, USA** timezone with the **Zen kernel**.

---

## Quick Start

1. Boot from the latest Arch Linux ISO
2. Verify internet connectivity: `ping archlinux.org`
3. If using WiFi: `iwctl` to connect
4. Download and run the installer:

```bash
# Clone or download the repository
git clone https://github.com/yourusername/arch-install.git
cd arch-install

# Run the unified installer
chmod +x install.sh
./install.sh
```

The installer will guide you through all phases automatically. You only need to run `./install.sh` at each phase:
- **Phase 1**: Initial setup (from Live ISO)
- **Phase 2**: Secure Boot configuration (after first reboot and BIOS setup)
- **Phase 3**: TPM2 setup (after second reboot)

---

## Detailed Installation Steps

### Phase 1: From Arch Live ISO

Run the installer while booted from the Arch ISO:

```bash
./install.sh
```

This will automatically execute scripts 01-05:
1. Disk preparation and LUKS encryption
2. Base system installation (USA mirrors, Zen kernel)
3. User account creation
4. Unified Kernel Image configuration
5. Bootloader and services setup

**After Phase 1 completes**, the installer will prompt you to:
1. Run: `sync && systemctl reboot --firmware-setup`
2. In UEFI/BIOS, enable Secure Boot **"Setup Mode"** (clears existing keys)
3. Save and exit, boot into your new Arch system

---

### Phase 2: Secure Boot Configuration

Boot into your newly installed Arch system, log in, and run:

```bash
cd ~/arch-install
sudo ./install.sh
```

This configures Secure Boot with custom keys and signs your EFI binaries.

**After Phase 2 completes**, reboot when prompted:
```bash
sudo reboot
```

---

### Phase 3: TPM2 Configuration

Boot back into your system and run:

```bash
cd ~/arch-install
sudo ./install.sh
```

This sets up TPM2 automatic disk unlocking (with optional PIN protection).

**After Phase 3 completes**, perform a final reboot to test:
```bash
sudo reboot
```

---

## Manual Installation (Advanced)

If you prefer to run scripts individually, you can execute them in order:

```bash
# Phase 1 (from Live ISO)
./01-disk-preparation.sh
./02-base-install.sh
./03-user-setup.sh
./04-kernel-setup.sh
./05-bootloader.sh

# Reboot and configure BIOS for Secure Boot Setup Mode

# Phase 2 (from installed system)
./06-secure-boot.sh

# Reboot

# Phase 3 (from installed system)
./07-tpm2-setup.sh
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
