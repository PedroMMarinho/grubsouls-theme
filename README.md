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

- If you have more than 4 boot options, the next entries won't be visible. If you want see all of them at once you can change `TODO put link this line` in the file theme.txt. There is a formula inside the file to guide you on that.

- If you have a boot entry with a large name you might need to change the width of the boot_menu. For that you can change `TODO put link this line`.

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