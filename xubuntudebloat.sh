#!/bin/bash

# Ask the user if they would like to remove XFCE
read -p "Would you like to purge XFCE4? (yes/no): " answer
if [ "$answer" == "yes" ]; then
    echo "Osaker"
    sudo apt purge xfdesktop4* --autoremove
else
    echo "Skipping removing XFCE, you dunst."
fi

# Install packages with apt
sudo apt install qt6-style-kvantum xdg-desktop-portal-gtk thunar picom flameshot xclip polybar alacritty power-profiles-daemon gnome-disk-utility brightnessctl gvfs xdg-user-dirs blueman bluez eza  qt6ct udiskie  pamixer playerctl pavucontrol gnome-keyring lxrandr rofi fonts-font-awesome qt5-style-kvantum nitrogen starship -y

echo "All packages have been installed."

# Make .local if it doesnt exist so stow doesnt symlink the entire .local folder
mkdir -p ~/.local
mkdir ~/.local/share

# Run stow to sync dotfiles
echo "Syncing dotfiles with stow..."
stow .

# Start daemons
echo "Starting services..."
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Set default terminal as Alacritty
echo "Default terminal as Alacritty..."
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

# Use the Catppucin theme for flatpak and GTK4
echo "Configuring flatpak to use the catppuccin GTK theme..."
mkdir -p ~/.config/gtk-4.0
ln -s  ~/.themes/Catppuccin-Macchiato-Standard-Teal-Dark/gtk-4.0/assets ~/.config/gtk-4.0
ln -s ~/.themes/Catppuccin-Macchiato-Standard-Teal-Dark/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
ln -s ~/.themes/Catppuccin-Macchiato-Standard-Teal-Darkgtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css

# Set flatpak overrides
sudo flatpak override --env=GTK_THEME=Catppuccin-Macchiato-Standard-Teal-Dark
sudo flatpak override --filesystem=~/.themes
sudo flatpak override --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-3.0
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --env=QT_STYLE_OVERRIDE=kvantum

# Install kvantum for flatpak
flatpak install org.kde.KStyle.Kvantum/x86_64/5.15-22.08 org.kde.KStyle.Kvantum/x86_64/5.15-23.08 org.kde.KStyle.Kvantum/x86_64/6.5 org.kde.KStyle.Kvantum/x86_64/6.6 org.kde.KStyle.Kvantum/x86_64/5.15 org.kde.KStyle.Kvantum/x86_64/5.15-21.08

# Ask the user if they would like to reboot
read -p "Would you like to reboot now (RECCOMENDED: YES)? (yes/no): " answer
if [ "$answer" == "yes" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Skipping reboot."
fi

