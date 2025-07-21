import re
import random
import shutil
import subprocess
import sys
from os.path import abspath, dirname
from pathlib import Path


# === Get background image argument or choose randomly ===
def get_background_image(theme_dir: Path) -> Path:
    if len(sys.argv) > 1:
        image = Path(sys.argv[1])
        if image.is_file():
            return image
        else:
            print(f"Error: Image {image} not found.")
            sys.exit(1)
    else:
        bg_dir = theme_dir / "backgrounds"
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

# === Replace a specific line in theme.txt ===
def patch(path: Path, index: int, new_line: str) -> None:
    lines = path.read_text().splitlines()
    lines[index] = new_line
    path.write_text("\n".join(lines) + "\n")

# === Count installed packages from fastfetch/neofetch ===
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
    old_lines = theme_txt.read_text().splitlines()
    new_line = f'\ttext = "{total_packages} {text}"'

    for i, line in enumerate(old_lines):
        if text in line:
            patch(theme_txt, i, new_line)
            print(f"[OK] Updated: {total_packages} {text}")
            return

    print(f"[WARN] Line containing '{text}' not found in theme.txt")

# === Main Execution ===
if __name__ == "__main__":
    themedir = Path(dirname(abspath(__file__)))

    background_image = get_background_image(themedir)
    update_background(background_image, themedir)
    update_package_count(themedir)
