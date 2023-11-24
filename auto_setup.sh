#!/bin/bash

# This script install and setup ubuntu server for production or devOps deploy

function full_install(){
	firewall_setup
	zsh_install
	p10k_install
	zsh_plugins_install
	lsd_install
	docker_install
	neofetch_install
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
	sudo apt install -y zsh
	# change user shell for zsh
	sudo usermod --shell /bin/bash $USER
}

# p10k
function p10k_install(){
	sudo apt install -y git
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
}

# Nerd fonts
function nerd_fonts_install(){
	wget -P /tmp https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
	sudo unzip -d /tmp/Hack /tmp/Hack.zip
	sudo mkdir /usr/share/fonts/truetype/HackNF
	sudo cp /tmp/Hack/*.ttf /usr/share/fonts/truetype/HackNF
	sudo fc-cache -f -v
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
	sudo curl -o /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/zsh-autosuggestions.zsh 

	sudo mkdir /usr/share/zsh-sudo/
	sudo touch /usr/share/zsh-sudo/sudo.plugin.zsh
	sudo curl -o /usr/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/sudo.plugin.zsh 

	# zshrc
	curl https://raw.githubusercontent.com/JuanCirera/Linux-Scripts/main/utils/.zshrc >> ~/.zshrc
}

# docker & docker-compose
function docker_install(){

	# custom_codename=$(sudo cat /etc/upstream-release/lsb-release | grep "DISTRIB_CODENAME" | cut -d'=' -f2)
	codename=""
	distID=$(sudo lsb_release -si)

	case $distID in
        Zorin)
            codename=focal
            ;;
        *)
			codename=$VERSION_CODENAME
            ;;
	esac

	# if [ "$distID" != "Ubuntu" ]; then
    # 	codename=$custom_codename
	# else
	# 	codename=$VERSION_CODENAME
	# fi

	sudo apt-get update

	sudo apt-get install -y ca-certificates curl gnupg
	install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg

	echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	"$(. /etc/os-release && echo "$codename")" stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	
	sudo apt-get update

	sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	# docker postinstall
	sudo usermod -aG docker $USER
}

function neofetch_install(){
	sudo apt install -y neofetch
}

while true; do
    clear
    echo "Automated setup for linux hosts."
    echo " "
    echo "Menu:"
    echo "1. Full install"
    echo "2. Install and setup zsh"
    echo "3. Install P10K"
    echo "4. Install lsd icons"
	echo "5. Install Nerd Fonts"
    echo "6. Install zsh plugins"
    echo "7. Enable firewall (ufw)"
    echo "8. Install docker"
	echo "9. Install neofetch"
    echo "0. Exit"

    read -p "Please, select a option: " option

	echo " "

    case $option in
        1)
            full_install
			echo " "
			echo "Setup completed!"
            ;;
        2)
            zsh_install
            ;;
        3)
            p10k_install
			echo " "
			echo "powerlevel10K added!"
            ;;
        4)
            lsd_install
			echo " "
			echo "lsd icons installed!"
            ;;
		5)
			nerd_fonts_install
			echo " "
			echo "Nerd fonts installed!"
            ;;
		6)
			zsh_plugins_install
			echo " "
			echo "zsh plugins added!"
            ;;
		7)
			firewall_setup
			echo " "
			echo "ufw firewall enabled!"
            ;;
		8)
			docker_install
			echo " "
			echo "docker install completed!"
            ;;
		9)
			neofetch_install
			echo " "
			echo "neofetch installed!"
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please, select a valid option (1-9)."
            ;;
    esac

	echo " "

    read -p "Press Enter to continue..."
done


