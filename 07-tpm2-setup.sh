#!/bin/bash
# Part 7: TPM2 Encryption Setup for Arch Linux
# For Chicago, USA timezone with Zen kernel
# Run this AFTER second reboot (after Secure Boot is enabled)

set -e

echo "=== Arch Linux Installation - Part 7: TPM2 Encryption ==="
echo ""

echo "=== Generating recovery key ==="
echo "IMPORTANT: Save this recovery key in a safe place!"
echo "You will need it if TPM unlocking fails in the future"
echo ""
sudo systemd-cryptenroll /dev/gpt-auto-root-luks --recovery-key
echo ""
read -p "Have you saved the recovery key? Press Enter to continue..."

echo ""
echo "=== Enrolling TPM2 for automatic unlocking ==="
echo ""
read -p "Do you want PIN protection? (yes/no): " USE_PIN

if [ "$USE_PIN" = "yes" ]; then
    echo "You will be prompted to set a PIN"
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 --tpm2-with-pin=yes /dev/gpt-auto-root-luks
else
    echo "Setting up TPM2 without PIN (automatic unlock)"
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/gpt-auto-root-luks
fi

echo ""
echo "=== Part 7 Complete ==="
echo "TPM2 encryption setup finished!"
echo ""
echo "FINAL STEP: Reboot to test automatic unlocking"
echo "If configured with PIN, you will be prompted for it on boot"
echo "If without PIN, the system should unlock automatically"
echo ""
echo "Installation complete! You can now install your desktop environment."
echo ""
read -p "Press Enter to acknowledge..."
