#!/bin/zsh

# ----------------------------- VARIABLES ----------------------------- #

DOWNLOADS_DIRECTORY="$HOME/Downloads/Setup"

read -p "Please enter your SUDO password: " -s PASSWORD

# ----------------------------- DOCKER-CONFIG ----------------------------- #

if ! groups | grep docker; then
    echo $PASSWORD | sudo groupadd docker
fi

echo $PASSWORD | sudo usermod -aG docker $USER && newgrp docker

# ----------------------------- ZINIT-CONFIG ----------------------------- #

sh -c "$(curl -fsSL https://git.io/zinit-install)"
echo -e "zinit light zsh-users/zsh-autosuggestions\nzinit light zsh-users/zsh-completions\nzinit light zdharma-continuum/fast-syntax-highlighting" >> ~/.zshrc

# ----------------------------- ASDF-CONFIG ----------------------------- #

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0 
echo ". $""HOME/.asdf/asdf.sh" >> ~/.zshrc
echo -e "fpath=($""{ASDF_DIR}/completions $""fpath)\nautoload -Uz compinit && compinit" >> ~/.zshrc
source ~/.zshrc

### JAVA ###
asdf plugin-add java
asdf install java openjdk-16.0.2
asdf install java adoptopenjdk-8.0.312+7
asdf global java system
echo ". ~/.asdf/plugins/java/set-java-home.zsh" >> ~/.zshrc

# ----------------------------- MYSQL-CONFIG ----------------------------- #

echo $PASSWORD | sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
echo $PASSWORD | sudo systemctl start mariadb
echo $PASSWORD | sudo mysql_secure_installation

# ----------------------------- CLEAN-CONFIG ----------------------------- #

source ~/.zshrc
sudo pacman -Rns $(pacman -Qtdq) --noconfirm