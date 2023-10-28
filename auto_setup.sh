#!/bin/bash

# This script install and setup ubuntu server for production or devOps deploy

function full_install(){
	firewall_setup
	zsh_install
	p10k_install
	zsh_plugins_install
	lsd_install
	docker_install
}

# UFW Firewall
function firewall_setup(){
	sudo ufw enable
	sudo ufw allow 22/tcp
}

# Wake On Lan
# TODO

# zsh
function zsh_install(){
	sudo apt install zsh 
	# change user shell for zsh
	sudo usermod --shell /bin/bash $USER
}

# p10k
function p10k_install(){
	sudo apt install git
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
}

# lsd icons
function lsd_install(){
	wget -P /tmp https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
	sudo dpkg -i /tmp/lsd_0.23.1_amd64.deb
}

# zsh plugins
function zsh_plugins_install(){
	# make files for zsh plugins
	sudo mkdir /usr/share/zsh-autosuggestions/
	sudo touch /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	sudo curl -o https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/zsh-autosuggestions.zsh /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

	sudo mkdir /usr/share/zsh-sudo/
	sudo touch /usr/share/zsh-sudo/sudo.plugin.zsh
	sudo curl -o https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/sudo.plugin.zsh /usr/share/zsh-sudo/sudo.plugin.zsh

	# zshrc
	curl https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/.zshrc >> ~/.zshrc
}

# docker & docker-compose
function docker_install(){
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
}

while true; do
    clear
    echo "Automated setup for linux hosts. Lambda Project"
    echo " "
    echo "Menu:"
    echo "1. Full install"
    echo "2. Install and setup zsh"
    echo "3. Install P10K"
    echo "4. Install lsd icons"
    echo "5. Install zsh plugins"
    echo "6. Enable firewall (ufw)"
    echo "7. Install docker"
    echo "0. Exit"

    read -p "Please, select a option (1-6): " option

	echo " "

    case $option in
        1)
            full_install
            ;;
        2)
            zsh_install
            ;;
        3)
            p10k_install
            ;;
        4)
            lsd_install
            ;;
		5)
			zsh_plugins_install
            ;;
		6)
			firewall_setup
            ;;
		7)
			docker_install
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please, select a valid option (1-5)."
            ;;
    esac

	echo " "

    read -p "Press Enter to continue..."
done


