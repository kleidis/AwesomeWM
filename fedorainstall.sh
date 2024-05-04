#!/bin/bash

# Update Fedora
echo "Updating Fedora..."
sudo dnf update -y

# Enable multiple COPR repositories
echo "Enabling COPR repositories..."
sudo dnf copr enable reikreider/SwayNotificationCenter -y
sudo dnf copr enable erikreider/SwayNotificationCenter -y

# Run stow to sync dotfiles
echo "Syncing dotfiles with stow..."
stow .

# Install multiple packages
echo "Installing packages..."
sudo dnf install hyprland hyprlock hypridle pyprland stow xdg-desktop-portal-gtk xdg-desktop-portal-hyprland nemo alacritty zsh power-profiles-daemon waybar gnome-disk-utility brightnessctl flatpak gvfs swaybg gvfs-mtp xdg-user-dirs network-manager-applet blueman bluez-tools eza bluez qt5ct qt6ct grim slurp udiskie kvantum-qt6 cliphist pamixer playerctl papirus-icon-theme pavucontrol wlogout SwayNotificationCenter xfce-polkit btop goverlay rofi-wayland sddm neofetch -y

# Start daemons
echo "Starting services..."
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable sddm
sudo systemctl set-default graphical.target

# Set default terminal as Alacritty
echo "Default terminal as Alacritty..."
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty


# Uninstall useless packages
sudo dnf remove wofi kitty -y 

# Update the user directories
echo "Updating user directories..."
xdg-user-dirs-update

# Use the Catppucin theme for flatpak
echo "Configuring flatpak to use the pywal GTK theme..."
sudo flatpak override --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-3.0
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --env=QT_STYLE_OVERRIDE=kvantum
flatpak install org.kde.KStyle.Kvantum/x86_64/5.15-22.08 org.kde.KStyle.Kvantum/x86_64/5.15-23.08 org.kde.KStyle.Kvantum/x86_64/6.5 org.kde.KStyle.Kvantum/x86_64/6.6 org.kde.KStyle.Kvantum/x86_64/5.15 org.kde.KStyle.Kvantum/x86_64/5.15-21.08

# Change default shell to zsh
echo "Changing shell to ZSH..."
chsh -s /bin/zsh

# Get the username
username=$(logname)

# Create a backup of the SDDM configuration file
echo "Creating a backup of the SDDM configuration file..."
sudo cp /etc/sddm.conf /etc/sddm.conf.bak

# Set up SDDM theme
echo "Setting up sddm theme..."
sudo cp -r  ~/hyprland-dotfiles/sddm/catppuccin-macchiato/ /usr/share/sddm/themes/
sudo sed -i.bak '/\[Theme\]/,/^\[/s/.*//g' /etc/sddm.conf && echo -e "[Theme]\nCurrent=catppuccin-macchiato" | sudo tee -a /etc/sddm.conf

# Ask the user if they would like to reboot
read -p "Would you like to reboot now (RECCOMENDED: YES)? (yes/no): " answer
if [ "$answer" == "yes" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Skipping reboot."
fi

