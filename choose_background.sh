#!/bin/bash

# === Config ===
theme_dir="grubsouls"
background_dir="background_galery"
output_file="background.png"

# === Locate script directory ===
SCRIPT_DIR="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
gallery_path="$SCRIPT_DIR/$background_dir"
target_path="$SCRIPT_DIR/$theme_dir/$output_file"

# === Check background directory ===
if [[ ! -d "$gallery_path" ]]; then
    echo "[ERROR] Background directory '$background_dir' not found."
    exit 1
fi

# === Gather all PNG files ===
mapfile -t all_pngs < <(find "$gallery_path" -maxdepth 1 -type f -iname "*.png")

if [[ ${#all_pngs[@]} -eq 0 ]]; then
    echo "[WARN] No PNG files found in $background_dir."
    exit 0
fi

# === Separate numbered and unnumbered files ===
declare -A numbered_files
declare -a unnumbered_files

for filepath in "${all_pngs[@]}"; do
    fname=$(basename "$filepath")
    if [[ "$fname" =~ ^\[(0*[0-9]+)\] ]]; then
        # Extract number with leading zeros removed
        num=$((10#${BASH_REMATCH[1]}))
        numbered_files[$num]="$filepath"
    else
        unnumbered_files+=("$filepath")
    fi
done

sorted_numbered=()
if [[ ${#numbered_files[@]} -gt 0 ]]; then
    for key in $(printf "%s\n" "${!numbered_files[@]}" | sort -n); do
        sorted_numbered+=("${numbered_files[$key]}")
    done
fi

mapfile -t sorted_unnumbered < <(printf '%s\n' "${unnumbered_files[@]}" | sort)

# === Warn if there are unnumbered files ===
if [[ ${#unnumbered_files[@]} -gt 0 ]]; then
    echo "[WARN] There are unnumbered files which will appear after the numbered list:"
    for f in "${unnumbered_files[@]}"; do
        echo "       - $(basename "$f")"
    done
fi

final_list=("${sorted_numbered[@]}" "${sorted_unnumbered[@]}")

# === Prompt user to choose ===
echo "📸 Choose a background from '$background_dir':"
for i in "${!final_list[@]}"; do
    fname=$(basename "${final_list[$i]}")
    echo "  [$i] $fname"
done

echo -n ">> "
read -r chosen_ind

# === Validate input ===
if ! [[ "$chosen_ind" =~ ^[0-9]+$ ]] || (( chosen_ind < 0 || chosen_ind >= ${#final_list[@]} )); then
    echo "[INFO] Invalid input — not changing background."
    exit 1
fi

# === Copy selected background ===
chosen_background="${final_list[$chosen_ind]}"
echo "[OK] Chose: $(basename "$chosen_background")"
cp -v "$chosen_background" "$target_path"
