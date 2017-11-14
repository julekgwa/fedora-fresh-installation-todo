#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

\cp -rf install.sh tmp_install.sh # create a copy of bash.sh file
GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
FILE_NAME="google-chrome-stable_current_x86_64.rpm"
RPMFUSION_VERSION=27

prompt_confirm() {
  while true; do
    read -r -n 1 -p "${1:-Continue?} : " REPLY
    case $REPLY in
      [yY]) echo ; return 0 ;;
      [nN]) echo ; return 1 ;;
      *) printf " \033[31m %s \n\033[0m" "invalid input"
    esac 
  done  
}

# set hostname

prompt_confirm "change your hostname? [Y/N]"

if [ $? -eq 0 ];
then
	while [[ -z "$NEW_HOSTNAME" ]]
    	do
        	read -p "Please enter new hostname: " NEW_HOSTNAME
	done
	echo -e "\n# set hostname" >> tmp_install.sh
	echo "hostnamectl set-hostname --static \"${NEW_HOSTNAME}\"" >> tmp_install.sh
fi

# install gnome tweak tool

prompt_confirm "install Gnome Tweak Tool? [Y/N]"

if [ $? -eq 0 ];
then
	echo -e "\n# install gnome tweak tool" >> tmp_install.sh
	echo "dnf -y install gnome-tweak-tool" >> tmp_install.sh
fi

# install Google chrome

prompt_confirm "install Google Chrome? [Y/N]"

if [ $? -eq 0 ];
then
	if [[ `wget -S --spider $GOOGLE_CHROME  2>&1 | grep 'HTTP/1.1 200 OK'` ]];
	then
		echo -e "\n# install Google chrome" >> tmp_install.sh
		echo "wget ${GOOGLE_CHROME} -O ${FILE_NAME}" >> tmp_install.sh
		echo -e "if [ \$? -eq 0 ];\nthen" >> tmp_install.sh
		echo "	printf \"Installing Google Chrome Dependencies\n\"" >> tmp_install.sh
		echo -e "\tdnf -y install lsb && dnf -y install libXScrnSaver && rpm -ivh ${FILE_NAME}" >> tmp_install.sh
		echo "else" >> tmp_install.sh
		echo "	printf \"Unable to download ${FILE_NAME}\n\"" >> tmp_install.sh
		echo "fi" >> tmp_install.sh
		echo "rm -rf ${FILE_NAME}" >> tmp_install.sh
	else
		printf "Google Chrome invalid url\n"
	fi
fi

# activate RPMFusion repo

prompt_confirm "activate RPMFusion repo [Fedora 22 and later]? [Y/N]"

if [ $? -eq 0 ];
then
	echo -e "\n# activate RPMFusion repo" >> tmp_install.sh
	echo "dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" >> tmp_install.sh
fi

# Installing VLC Media Player

prompt_confirm "install VLC Media Player? [Y/N]"

if [ $? -eq 0 ];
then
	echo -e "\n# installing VLC Media Player" >> tmp_install.sh
	echo "COUNT=$(ls /etc/yum.repos.d/ | grep -c rpmfusion)" >> tmp_install.sh
	echo -e "if [ \$COUNT -gt 0 ];\nthen" >> tmp_install.sh
	echo -e "\tdnf install -y vlc" >> tmp_install.sh
	echo "else" >> tmp_install.sh
	echo "	printf \"\${RED}\${BOLD}Unable to install VLC\${NC}\n\"" >> tmp_install.sh
	echo "	printf \"\${RED}\${BOLD}You need to activate RPMFusion repo, to install VLC \${NC}\n\"" >> tmp_install.sh
	echo "	prompt_confirm \"activate RPMFusion repo [Fedora 22 and later]? [Y/N]\"" >> tmp_install.sh
	echo -e "\tif [ \$? -eq 0 ];\n\tthen" >> tmp_install.sh
	echo "		dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" >> tmp_install.sh
	echo -e "\t\tdnf install -y vlc" >> tmp_install.sh
	echo -e "\tfi" >> tmp_install.sh
	echo "fi" >> tmp_install.sh
fi

# install docky

prompt_confirm "install Docky? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Docky" >> tmp_install.sh
	echo "dnf -y install docky" >> tmp_install.sh
fi

# install GIMP

prompt_confirm "install GIMP? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install GIMP" >> tmp_install.sh
	echo "dnf -y install gimp" >> tmp_install.sh
fi

# install pidgin

prompt_confirm "install pidgin? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install pidgin" >> tmp_install.sh
	echo "dnf -y install pidgin" >> tmp_install.sh
fi

# install transmission

prompt_confirm "install transmission? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install transmission" >> tmp_install.sh
	echo "dnf -y install transmission" >> tmp_install.sh
fi

# install qbittorrent

prompt_confirm "install qbittorrent? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install qbittorrent" >> tmp_install.sh
	echo "dnf -y install qbittorrent" >> tmp_install.sh
fi

# install VirtualBox

prompt_confirm "install VirtualBox? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install VirtualBox" >> tmp_install.sh
	echo "dnf -y install VirtualBox" >> tmp_install.sh
fi

# install Spotify

prompt_confirm "install Spotify? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Spotify" >> tmp_install.sh
	echo "dnf -y config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo && dnf -y install spotify-client" >> tmp_install.sh
fi

# install Wine

prompt_confirm "install Wine? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Wine" >> tmp_install.sh
	echo "dnf -y install wine" >> tmp_install.sh
fi

# install Youtube-dl

prompt_confirm "install Youtube-DL? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Youtube-dl" >> tmp_install.sh
	echo "dnf -y install youtube-dl" >> tmp_install.sh
fi

# install simple scan

prompt_confirm "install Simple Scan? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install simple scan" >> tmp_install.sh
	echo "dnf -y install simple-scan" >> tmp_install.sh
fi

# install Fedora Media Writer

prompt_confirm "install Fedora Media Writer? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Fedora Media Writer" >> tmp_install.sh
	echo "dnf -y install mediawriter" >> tmp_install.sh
fi

# install gnome music player

prompt_confirm "install Gnome Music Player? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Gnome Music Player" >> tmp_install.sh
	echo "dnf -y install gnome-music" >> tmp_install.sh
fi

# install guake

prompt_confirm "install Guake? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Guake" >> tmp_install.sh
	echo "dnf -y install guake" >> tmp_install.sh
fi


# install sublime text

prompt_confirm "install Sublime Text? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install sublime-text" >> tmp_install.sh
	echo "rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg && dnf -y config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo && dnf -y install sublime-text" >> tmp_install.sh
fi

# install vs code

prompt_confirm "install Visual Studio Code? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Visual Studio Code" >> tmp_install.sh
	echo "rpm --import https://packages.microsoft.com/keys/microsoft.asc && sh -c 'echo -e \"[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\" > /etc/yum.repos.d/vscode.repo' && dnf -y check-update && dnf -y install code" >> tmp_install.sh
fi

sh ./tmp_install.sh

prompt_confirm "Delete tmp_install.sh file? [Y/N]"
if [ $? -eq 0 ];
then
	rm tmp_install.sh
fi
