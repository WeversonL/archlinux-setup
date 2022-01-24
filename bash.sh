#!/bin/bash

# ----------------------------- VARIABLES ----------------------------- #

DOWNLOADS_DIRECTORY="$HOME/Downloads/Setup"

PAMAC_URL="https://aur.archlinux.org/pamac-aur.git"

PAMAC_DIRECTORY="$DOWNLOADS_DIRECTORY/pamac"

read -p "Please enter your SUDO password: " -s PASSWORD

# ----------------------------- PROGRAMS ----------------------------- #

ESSENTIALS=(
    base-devel
    linux-headers
    nvidia
    nvidia-dkms
    nvidia-utils
    lib32-nvidia-utils
    vim
    git
    curl
    wget
    net-tools
    openssh
    tmux
    zip
    unzip
    unrar
    p7zip
    android-tools
    rclone
    youtube-dl
    hping
    ncat
    nmap
    whois
    tor
    jdk-openjdk
    maven
    mariadb
    postgresql
    docker
    docker-compose
    pacman-contrib
)

OPTIONALS=(
    ttf-inconsolata
    ttf-cascadia-code
    ttf-fira-code
    ttf-fira-mono
    gedit
    gparted
    gnome-tweaks
    grub-customizer
    flameshot
    qbittorrent
    sqlitebrowser
    firefox
    lutris
    scrcpy
    peek
    telegram-desktop
    obs-studio
    remmina
    nvidia-settings
    nvidia-prime
    nvidia-cg-toolkit
    vulkan-headers
    vulkan-radeon
    lib32-vulkan-radeon
    vulkan-icd-loader
    lib32-vulkan-icd-loader
    mesa
    lib32-mesa
)

# ----------------------------- EXECUTION ----------------------------- #

mkdir -p "$DOWNLOADS_DIRECTORY"

# ----------------------------- ENABLING MULTILIB ----------------------------- #

echo $PASSWORD | sudo -S chmod 777 /etc/pacman.conf
echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo $PASSWORD | sudo -S chmod 644 /etc/pacman.conf

sudo pacman -Syu --noconfirm

### Install programs from essential list ###

clear
for program in ${ESSENTIALS[@]}; do
    echo $PASSWORD | sudo -S pacman -S --needed --noconfirm $program
done

### Install programs from optional list ###

clear
read -p "Do you want to install OPTIONAL PACKAGES? [Y/n]: " preference
case $preference in 
    Y*|y*|"" )
        for program in ${OPTIONALS[@]}; do
            echo $PASSWORD | sudo -S pacman -S --needed --noconfirm $program
        done
        ;;
    N*|n* ) 
        continue;;
esac

### PAMAC ###

git clone $PAMAC_URL $PAMAC_DIRECTORY && cd $PAMAC_DIRECTORY && makepkg -si && cd $HOME

### OHMYZSH ###

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

clear
echo -e "PLEASE RESTART YOUR COMPUTER TO CONTINUE CHANGES WITH SCRIPT 'zsh.sh'\n"