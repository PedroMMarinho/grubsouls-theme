# Grub Souls III 

A GRUB theme inspired by the Dark Souls series.

Put a screenshot here. TODO


# Installation

- Clone or download the theme repository:

```bash
git clone TODO
```

## ⚙️ Manually

If you prefer to install the theme manually:

- (optional) Before you copy the theme you can:

    - Choose any background you'd like:
        ```bash
        # Run the script
        ./choose_background.sh
        # Or copy a custom image to grubsouls/background.png
        ```
    - The script will allow you to choose an image from `backgrounds_options`. If you do not want to run the script, you can always copy any image from that folder to use as background.

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
  ```
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