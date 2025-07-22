import re
import random
import shutil
import subprocess
import sys
from os.path import abspath, dirname
from pathlib import Path


# === Get background image argument or choose randomly ===
def get_background_image(theme_dir: Path) -> Path:
    bg_dir = theme_dir / "backgrounds"

    if len(sys.argv) > 1:
        image = Path(sys.argv[1])
        path = bg_dir / image
        if path.is_file():
            return path
        else:
            print(f"Error: Image {image} not found.")
            sys.exit(1)
    else:
        if not bg_dir.is_dir():
            print(f"Error: No 'backgrounds' directory found in {theme_dir}")
            sys.exit(1)

        list_background_files = [f for f in bg_dir.iterdir() if f.is_file() and not f.name.startswith('.')]
        if not list_background_files:
           print("Error: No images found in 'backgrounds/' directory.")
           sys.exit(1)
        return random.choice(list_background_files)

# === Copy new background image ===
def update_background(image: Path, theme_dir: Path) -> None:
    dest = theme_dir / "background.png"
    shutil.copy(image, dest)
    print(f"[OK] Background updated: {dest.name}")


def update_package_count(theme_dir: Path) -> None:
    for command in [["fastfetch", "-c", "neofetch"], ["neofetch"]]:
        try:
            output = subprocess.run(command, stdout=subprocess.PIPE, text=True, check=True).stdout
            break
        except (FileNotFoundError, subprocess.CalledProcessError):
            continue
    else:
        print("Error: Neither Fastfetch or Neofetch are available.")
        return

    for line in output.splitlines():
        if "Packages" in line:
            numbers = [int(n) for n in re.findall(r"\d+", line)]
            total_packages = sum(numbers)
            break
    else:
        print("Error: Could not find package count.")
        return

    theme_txt = theme_dir / "theme.txt"
    text = "Bosses Slain"
    new_line = f'   text = "{total_packages} {text}"'

    lines = theme_txt.read_text().splitlines()
    updated = False

    for i, line in enumerate(lines):
        if text in line:
            lines[i] = new_line
            updated = True

    if updated:
        theme_txt.write_text("\n".join(lines) + "\n")
        print(f"[OK] Updated all instances: {total_packages} {text}")
    else:
        print(f"[WARN] Line containing '{text}' not found in theme.txt")


# === Main Execution ===
if __name__ == "__main__":
    themedir = Path(dirname(abspath(__file__)))

    background_image = get_background_image(themedir)
    update_background(background_image, themedir)
    update_package_count(themedir)
    
