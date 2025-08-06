The Full Darksouls Experience:

| *> Dark Souls Grub <* | [Plymouth Loading Menu](https://github.com/PedroMMarinho/plymouth-ds3)
| --- | ---  |

# Grub Souls III 

A GRUB theme inspired by the Dark Souls series.

![grub souls preview](preview/grub-preview.gif)

# Installation

- Clone or download the theme repository:

```bash
git clone git@github.com:PedroMMarinho/grubsouls-theme.git
```

## Manually

If you prefer to install the theme manually:

- (optional) Before you copy the theme you can:

    - Choose any background you'd like:
        ```bash
        # Run the script
        ./choose_background.sh
        # Or copy a custom image to grubsouls/background.png
        ```
    - The script will allow you to choose an image from `background_galery`. If you do not want to run the script, you can always copy any image from that folder to use as background.

    - For alternate backgrounds on boot, copy the images you'd like to shuffle to **grubsouls/backgrounds**. This requires an extra step so checkout the `Configuration` section.
    
- **Check your GRUB directory:**
   - Usually one of:
     - `/boot/grub`
     - `/boot/grub2`

- **Copy the theme to GRUB themes directory**
   ```bash
   cd grubsouls-theme/
   sudo cp -r ./grubsouls $(GRUB_DIR)/themes/
    ```

- **Edit GRUB configuration**
  - Open `/etc/default/grub` with a text editor and add or modify the line:
  
       ```
       GRUB_THEME="/boot/grub/themes/grubsouls/theme.txt"
    ```

- **Finally update your grub config by running** 
  ```bash
  sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

- And that's it. You are good to go.

## Using the Script

- Run the installation script as root:

```bash
sudo ./install_theme.sh
```

- This will make it easier to install the theme, the background update and the console background.

# Configuration

## Adjusting Height and Width for a different amount of boot options:

- If you have more than 4 boot options, the next entries won't be visible. If you want see all of them at once you can change [this line](https://github.com/PedroMMarinho/grubsouls-theme/blob/main/grubsouls/theme.txt#L28)  in the file theme.txt. There is a formula inside the file to guide you on that.

- If you have a boot entries with a large names you might need to change the width of the boot_menu. For that you can change [this line](https://github.com/PedroMMarinho/grubsouls-theme/blob/main/grubsouls/theme.txt#L21).

## Changing the names and classes of the boot entries:

- If you want to change the name of the boot entries, however, what you can do is use a custom file with all the menu entries, and change their name. 
What I've done is: 
       
    - **DO THIS AT YOUR OWN RISK**, if you miss something you might break your boot.

       - Go to where your `grub.cfg` file is located and check all the menu entries you have.

       - **Copy** all the entries you want to **edit** and put them into the file `40_custom` located in `/etc/grub.d/`. If that file does not exist create a new executable that will be loaded into the `grub.cfg`. **Be sure to copy them correctly**, if not you might break your boot system.
  
       - After that, you should disable the files that are generating the entries so you don't get **duplicates**. 
  
       - My arch entry starts like this: `menuentry 'Champion of Ash' --class arch`. **'Champion of Ash'** is the name of the entry, you can change that to whatever you'd like. The **class** is important so the icon that is on the left of the entry changes. As the name is `arch`, grub will look into the `icons` folder if there is an `arch.png` and will use it.
  
      - Finally don't forget to regenerate the `grub.cfg` by running:
        ```bash
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        ```

Reiterating [Lxtharia](https://github.com/Lxtharia/minegrub-theme?tab=readme-ov-file#setting-the-console-background)


## Setting the console background

When in grub, pressing **'c'** opens the grub console. If you want that console to have a background you can specify `GRUB_BACKGROUND=<path>` in `/etc/defaults/grub`

```bash
# Create a backup of the file first
cp /etc/grub.d/00_header ./00_header.bak
# replace the elif in that line with an fi; if
sed --in-place -E 's/(.*)elif(.*"x\$GRUB_BACKGROUND" != x ] && [ -f "\$GRUB_BACKGROUND" ].*)/\1fi; if\2/' /etc/grub.d/00_header
```

Now you can set:
```
GRUB_BACKGROUND="/boot/grub/themes/minegrub/terminal_background.png"
```

And don't forget to regenerate the `grub.cfg`.


## Updating background and "x Bosses Slain" text after every boot


The `update_theme.py` script updates the amount of packages currently installed and randomly chooses a file from the folder `backgrounds/` as the background image.

For this to work make sure you have:

- `fastfetch` or `neofetch` is installed
- Simple Python 3 (or other variation) installation 
- Put all backgrounds you want to randomly choose from in `./grubsouls/backgrounds/`. You can also add your own images :) 
- If you want a certain background to be used on the next boot you can run `python update_theme.py <BACKGROUND_FILE_NAME>`

To have this `automatically` running you'll to do the following:

> For systemd

- Edit `./grubsouls-update.service` to use `/boot/grub2/` if necessary.

- Copy .`/grubsouls-update.service` to `/etc/systemd/system`.

- Enable the service: `systemctl enable grubsouls-update.service`

- If for some reason it does not update after boot you can run `systemctl status grubsouls-update.service` and check for errors.


## A Big Thanks to

- [Lxtharia](https://github.com/Lxtharia) for sharing his work [Minegrub](https://github.com/Lxtharia/minegrub-theme) (Helped a ton for development reference!!!)
- This beatifull collection of themes that also inspired me and helped me learn (https://github.com/Jacksaur/Gorgeous-GRUB)
- Documentation of course (http://web.archive.org/web/20241209100014/http://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial), (https://www.gnu.org/software/grub/manual/grub/html_node/Theme-file-format.html).
