#!/usr/bin/env bash

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

function execution(){

    # ----------------------------- EXECUTION ----------------------------- #

    git clone "$YAY_URL" "$BUILD_DIRECTORY" > /dev/null 2>&1

    # ----------------------------- ENABLING MULTILIB ----------------------------- #

    chmod 777 /etc/pacman.conf
    echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    chmod 644 /etc/pacman.conf

    pacman -S archlinux-keyring > /dev/null 2>&1
    pacman -Syu --noconfirm > /dev/null 2>&1

    ### Install programs from essential list ###

    for program in "${ESSENTIALS[@]}"; do
        install "$program"
        pacman -S --needed --noconfirm "$program" > /dev/null 2>&1
        installed "$program"
    done

    ### Install programs from optional list ###

    read -rp "Do you want to install OPTIONAL PACKAGES? [Y/n]: " preference
    case $preference in
    Y* | y* | "")
        for program in "${OPTIONALS[@]}"; do
            install "$program"
            pacman -S --needed --noconfirm "$program" > /dev/null 2>&1
            installed "$program"
        done;;
    N* | n*)
        return;;
    esac

    ### YAY ###

    install "yay"
    cd "$YAY_DIRECTORY" && makepkg -si > /dev/null 2>&1
    installed "yay"

    # ----------------------------- DOCKER-CONFIG ----------------------------- #

    if ! groups | grep docker > /dev/null 2>&1; then
        groupadd docker > /dev/null 2>&1
    fi

    usermod -aG docker "$NORMAL_USER" && newgrp docker

    # ----------------------------- MYSQL-CONFIG ----------------------------- #

    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    systemctl start mariadb
    mysql_secure_installation

    pacman -Rns "$(pacman -Qtdq)" --noconfirm > /dev/null 2>&1

}

# ----------------------------- SCRIPT SETTINGS ----------------------------- #

BUILD_DIRECTORY="/tmp"

YAY_URL="https://aur.archlinux.org/yay.git"

YAY_DIRECTORY="$BUILD_DIRECTORY/yay"

NORMAL_USER=$(getent passwd 1000 | cut -d ":" -f1)

# Colours Variables
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'

function banner(){

    echo -e "$CYAN" ""
    echo -e "     _             _     _     _                    ____       _               
    / \   _ __ ___| |__ | |   (_)_ __  _   ___  __ / ___|  ___| |_ _   _ _ __  
   / _ \ | '__/ __| '_ \| |   | | '_ \| | | \ \/ / \___ \ / _ \ __| | | | '_ \ 
  / ___ \| | | (__| | | | |___| | | | | |_| |>  <   ___) |  __/ |_| |_| | |_) |
 /_/   \_\_|  \___|_| |_|_____|_|_| |_|\__,_/_/\_\ |____/ \___|\__|\__,_| .__/ 
                                                                        |_|    
"
    echo -e "$LIGHTGRAY ---------------------------------------------------------------------------------"
    echo -e "$RESTORE"

}

function checkConnection(){
    echo -e "$LYELLOW [ * ]$BLUE Checking for internet connection$RESTORE"
    sleep 1
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "$RED [ X ]$BLUE Internet Connection ➜$RED OFFLINE!$RESTORE\n";
        echo -e "$RED Sorry, you really need an internet connection....$RESTORE"
        exit 0
    else
        echo -e "$GREEN [ ✔ ]$BLUE Internet Connection ➜$GREEN CONNECTED!$RESTORE\n";
        sleep 1
    fi
}

function install(){
    local programName=$1
    echo -e "$BLUE [ * ]$LYELLOW $programName $RESTORE -> $BLUE Installing..."
}

function installed(){
    local programName=$1
    echo -e "$GREEN [ ✔ ]$GREEN $programName $RESTORE -> $BLUE INSTALLED\n"
}

function end(){
    echo -e "$CYAN\n Restart your PC and run zsh.sh [with ZSH Shell]..... ;)"
    exit 0
}

main(){
    banner
    checkConnection
    execution
    end
}

main
