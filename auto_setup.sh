#!/bin/bash

# This script install and setup ubuntu server for production or devOps deploy

# UFW Firewall
sudo enable ufw
sudo ufw allow 22/tcp

# Wake On Lan
 

# zsh
sudo apt install zsh 

# p10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# lsd icons
wget https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb /tmp
dpkg -i /tmp/lsd_0.23.1_amd64.deb

# make files for zsh plugins
sudo mkdir /usr/share/zsh-autosuggestions/
sudo touch /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
sudo curl https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/zsh-autosuggestions.zsh > /usr/share/zsh-sudo/zsh-autosuggestions.zsh

sudo mkdir /usr/share/zsh-sudo/
sudo touch /usr/share/zsh-sudo/sudo.plugin.zsh
sudo curl https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/sudo.plugin.zsh > /usr/share/zsh-sudo/sudo.plugin.zsh

# zshrc
curl https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/.zshrc >> ~/.zshrc

# docker & docker-compose
sudo apt-get install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# docker postinstall
sudo usermod -aG docker $USER

# change user shell for zsh
sudo usermod --shell /bin/bash $USER


