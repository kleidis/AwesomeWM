#!/bin/bash

# Define packages to be installed with pacman
pacman_packages=(
    stow
    xdg-desktop-portal-gtk
    nemo
    alacritty
    zsh
    power-profiles-daemon
    waybar
    gnome-disk-utility
    brightnessctl
    flatpak
    gvfs
    swaybg 
    gvfs-mtp
    xdg-user-dirs
    network-manager-applet
    blueman
    bluez-utils
    eza
    bluez
    qt6-svg 
    qt6-declarative
    ttf-font-awesome
    qt5ct
    qt6ct
    grim
    slurp
    udiskie
    kvantum
    kvantum-qt5 
    cliphist
    pamixer
    playerctl
    papirus-icon-theme
    pavucontrol
)

# Define packages to be installed with yay
yay_packages=(
    wlogout
    waybar-module-pacman-updates-git
    swaync
    hyprlock-git
    rofi-lbonn-wayland-git
    pyprland
    hypridle-git
    pfetch
    xfce-polkit
    waypaper-git
    hyprshot-git
)

# Install packages with pacman
for pkg in "${pacman_packages[@]}"; do
    echo "Installing $pkg with pacman..."
    sudo pacman -S --noconfirm $pkg
    sleep 2 # Delay for readability and control
done

# Install packages with yay
for pkg in "${yay_packages[@]}"; do
    echo "Installing $pkg with yay..."
    yay -S --noconfirm $pkg
    sleep 2 # Delay for readability and control
done

echo "All packages have been installed."


# Run stow to sync dotfiles
echo "Syncing dotfiles with stow..."
stow .

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
sudo pacman -Rsn kitty dunst dolphin vim wofi

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

# Make SDDM conf 
sudo touch /etc/sddm.conf 

# Create a backup of the SDDM configuration file
echo "Creating a backup of the SDDM configuration file..."
sudo cp /etc/sddm.conf /etc/sddm.conf.bak

# Set up SDDM theme
echo "Setting up sddm theme..."
sudo cp -r  ~/dotfiles/sddm/catppuccin-macchiato/ /usr/share/sddm/themes/
sudo sed -i.bak '/\[Theme\]/,/^\[/s/.*//g' /etc/sddm.conf && echo -e "[Theme]\nCurrent=catppuccin-macchiato" | sudo tee -a /etc/sddm.conf

# Ask the user if they would like to reboot
read -p "Would you like to reboot now (RECCOMENDED: YES)? (yes/no): " answer
if [ "$answer" == "yes" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Skipping reboot."
fi

