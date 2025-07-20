#!/bin/bash

# === 1. Must be run as root ===
if [[ $(id -u) -ne 0 ]]; then
    echo "[ERROR] This script must be run as root."
    exit 1
fi

# === 2. Get script directory safely ===
SCRIPT_DIR="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
if [[ -z "$SCRIPT_DIR" || "$SCRIPT_DIR" == "/" ]]; then
    echo "[ERROR] Invalid script directory. Exiting."
    exit 1
fi

# === 3. Detect GRUB directory ===
if [[ -d /boot/grub ]]; then
    grub_path="/boot/grub"
elif [[ -d /boot/grub2 ]]; then
    grub_path="/boot/grub2"
else
    echo "[ERROR] Could not find /boot/grub or /boot/grub2"
    exit 1
fi

# === 4. Theme path ===
theme_name="darksouls"
theme_path="$grub_path/themes/$theme_name"

# === 5. Confirm and copy theme ===
echo
read -r -p "[?] Install or update theme to '$theme_path'? [Y/n] " -n 1 copy_theme
echo
if [[ "$copy_theme" =~ ^[nN]$ ]]; then
    echo "[INFO] Skipping theme installation."
else
    if [[ ! -d "$SCRIPT_DIR/$theme_name" ]]; then
        echo "[ERROR] Theme folder '$theme_name' not found in script directory."
        exit 1
    fi
    echo "[INFO] Installing theme..."
    mkdir -p "$grub_path/themes/"
    cp -ruv "$SCRIPT_DIR/$theme_name" "$grub_path/themes/"
    echo "[OK] Theme copied successfully."
fi

# === 6. (Optional) Patch 00_header for console background support ===
echo
read -r -p "[?] Patch GRUB to support GRUB_BACKGROUND for console? [y/N] " -n 1 patch_header
echo
if [[ "$patch_header" =~ ^[yY]$ ]]; then
    header_file="/etc/grub.d/00_header"
    backup_file="/etc/grub.d/00_header.bak"

    echo "[INFO] Backing up $header_file to $backup_file"
    cp --no-clobber "$header_file" "$backup_file"

    echo "[INFO] Patching file..."
    sed -i -E "s/(.*)elif(.*\"x\\\$GRUB_BACKGROUND\" != x ] && \[ -f \"\\\$GRUB_BACKGROUND\" \].*)/\1fi; if\2/" "$header_file"
    echo "[OK] Patch applied."
else
    echo "[INFO] Skipped patching grub config."
fi

# === 7. Final instructions ===
echo
echo "========= ✅ Installation Complete ========="
echo "👉 Edit the following lines in /etc/default/grub:"
echo
echo "    GRUB_THEME=\"$theme_path/theme.txt\""
echo "    GRUB_BACKGROUND=\"$theme_path/your_background.png\"  # (if you patched)"
echo
echo "Then run:"
echo "    sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo "============================================"
