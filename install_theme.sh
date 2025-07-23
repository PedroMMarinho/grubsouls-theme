#!/bin/bash

# === Config ===
theme_name="grubsouls"
systemd_service="grubsouls-update.service"
background_script="choose_background.sh"

# === 1. Root Check ===
if [[ $(id -u) -ne 0 ]]; then
    echo "[ERROR] This script must be run as root."
    exit 1
fi

# === 2. Determine Script Directory ===
SCRIPT_DIR="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
if [[ -z "$SCRIPT_DIR" || "$SCRIPT_DIR" == "/" ]]; then
    echo "[ERROR] Invalid script directory. Exiting."
    exit 1
fi

# === 3. Locate GRUB Directory ===
if [[ -d /boot/grub ]]; then
    grub_path="/boot/grub"
elif [[ -d /boot/grub2 ]]; then
    grub_path="/boot/grub2"
else
    echo "[ERROR] Could not find /boot/grub or /boot/grub2"
    exit 1
fi

theme_path="$grub_path/themes/$theme_name"

# === 4. Optional Background Selection ===
echo
read -rp "[?] Choose a specific background from ./background_galery/? [y/N] " -n 1 choose_bg
echo
if [[ "$choose_bg" =~ [yY] ]]; then
    if [[ -x "$SCRIPT_DIR/$background_script" ]]; then
        echo "[INFO] Running background selection script..."
        "$SCRIPT_DIR/$background_script"
    else
        echo "[WARN] Script '$background_script' not found or not executable."
    fi
else
    echo "[INFO] Skipping background selection."
fi

# === 5. Install Theme ===
echo
read -rp "[?] Copy/update theme to '$theme_path'? [Y/n] " -n 1 copy_theme
echo
if [[ ! "$copy_theme" =~ ^[nN]$ ]]; then
    if [[ ! -d "$SCRIPT_DIR/$theme_name" ]]; then
        echo "[ERROR] Theme folder '$theme_name' not found in script directory."
        exit 1
    fi
    echo "[INFO] Copying theme..."
    mkdir -p "$grub_path/themes/"
    cp -ruv "$SCRIPT_DIR/$theme_name" "$grub_path/themes/"
    echo "[OK] Theme copied."
else
    echo "[INFO] Skipping theme installation."
fi

# === 6. Optional systemd Service Install ===
echo
read -rp "[?] Install systemd service to update theme on boot? [y/N] " -n 1 install_service
echo
if [[ "$install_service" =~ [yY] ]]; then
    if [[ -f "$SCRIPT_DIR/$systemd_service" ]]; then
        echo "[INFO] Installing service..."
        cp -uv "$SCRIPT_DIR/$systemd_service" /etc/systemd/system/
    else
        echo "[WARN] Service file '$systemd_service' not found."
    fi
else
    echo "[INFO] Skipping service installation."
fi

# === 7. Optional Patch for GRUB_BACKGROUND ===
echo
read -rp "[?] Patch /etc/grub.d/00_header for GRUB_BACKGROUND support? [y/N] " -n 1 patch_header
echo
if [[ "$patch_header" =~ [yY] ]]; then
    header_file="/etc/grub.d/00_header"
    backup_file="$SCRIPT_DIR/00_header.bak"

    echo "[INFO] Backing up $header_file to $backup_file"
    cp --no-clobber "$header_file" "$backup_file"

    echo "[INFO] Applying patch..."
    sed -i -E "s/(.*)elif(.*\"x\\\$GRUB_BACKGROUND\" != x ] && \[ -f \"\\\$GRUB_BACKGROUND\" \].*)/\1fi; if\2/" "$header_file"
    echo "[OK] Patch applied."
else
    echo "[INFO] Skipping patch."
fi

# === 8. Final Output ===
echo
echo "========= ✅ Installation Complete ========="
echo "👉 Edit the following lines in /etc/default/grub:"
echo
echo "    GRUB_THEME=\"$theme_path/theme.txt\""
echo "    GRUB_BACKGROUND=\"$theme_path/terminal_background.png\""
echo
echo "Then run:"
echo "    sudo grub-mkconfig -o $grub_path/grub.cfg"
echo "============================================"
