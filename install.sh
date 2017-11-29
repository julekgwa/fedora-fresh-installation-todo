#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# EXTENSIONS

# Dash to dock
DASH_TO_DOCK="dash-to-dock@micxgx.gmail.com.shell-extension.zip?version_tag=2051"
DASH_TO_DOCK_UUID="dash-to-dock@micxgx.gmail.com"

# Dynamic top Bar
DYNAMIC_TOP_BAR="dynamicTopBar@gnomeshell.feildel.fr.shell-extension.zip?version_tag=5866"
DYNAMIC_TOP_BAR_UUID="dynamicTopBar@gnomeshell.feildel.fr"

# Net Speed
NET_SPEED="netspeed@hedayaty.gmail.com.shell-extension.zip?version_tag=3324"
NET_SPEED_UUID="netspeed@hedayaty.gmail.com"

# Alternate Tab
ALTENATE_TAB="alternate-tab@gnome-shell-extensions.gcampax.github.com.shell-extension.zip?version_tag=1006"
ALTENATE_TAB_UUID="alternate-tab@gnome-shell-extensions.gcampax.github.com"

# Workspace to Dock
WORKSPACE_TO_DOCK="workspaces-to-dock@passingthru67.gmail.com.shell-extension.zip?version_tag=3685"
WORKSPACE_TO_DOCK_UUID="workspaces-to-dock@passingthru67.gmail.com"

enable_user_themes() {
	echo -e "\nenable_user_themes() {
	EXTENSIONS=\$(gsettings get org.gnome.shell enabled-extensions)
	if [[ \$EXTENSIONS == *\"user-theme@gnome-shell-extensions.gcampax.github.com\"* ]]; then
		return
	fi

	TMP=\"\${EXTENSIONS:: -1}\"
	TMP+=\", 'user-theme@gnome-shell-extensions.gcampax.github.com']\"
	
    # enable extension
    gsettings set org.gnome.shell enabled-extensions \"\$TMP\"
}" >> tmp_install.sh
}

install_extenstions() {
	echo -e "\n# install extensions
install_extension() {
	DOWNLOAD_URL=\$1
	UUID=\$2

	# check if extension is enabled
	EXTENSIONS=\$(gsettings get org.gnome.shell enabled-extensions)
	if [[ \$EXTENSIONS == *\"\${UUID}\"* ]]; then
		return
	fi

	wget -O /tmp/extension.zip \"https://extensions.gnome.org/download-extension/\${DOWNLOAD_URL}\"
	mkdir -p \"/home/\$SUDO_USER/.local/share/gnome-shell/extensions/\${UUID}\"
	unzip /tmp/extension.zip -d \"/home/\$SUDO_USER/.local/share/gnome-shell/extensions/\${UUID}\"
	EXTENSIONS=\$(gsettings get org.gnome.shell enabled-extensions)
	TMP=\"\${EXTENSIONS:: -1}\"
	TMP+=\", '\${UUID}']\"
	
    # enable extension
    gsettings set org.gnome.shell enabled-extensions \"\$TMP\"
}" >> tmp_install.sh
}

# display message to the user
showMessage() {
	echo -e "\nshowMessage()
{
	echo -e \" [ \\\E[32m\\\033[1mOK\\\033[0m ]  \$1\"
}" >> tmp_install.sh
}

create_tmp_install_file() {
	echo -e "#!/bin/bash\n
GREEN='\\\033[0;32m'
RED='\\\033[0;31m'
NC='\\\033[0m' # No Color\n
prompt_confirm() {
\twhile true; do
\t\tread -r -n 1 -p \"\${1:-Continue?} : \" REPLY
\t\tcase \$REPLY in
\t\t\t[yY]) echo ; return 0 ;;
\t\t\t[nN]) echo ; return 1 ;;
\t\t\t*) printf \" \\\033[31m %s \\\n\\\033[0m\" \"invalid input\"
\t\tesac
\tdone\n}" > tmp_install.sh

echo -e "\n# update system
dnf -y update\ndnf -y install unzip" >> tmp_install.sh
}

# create tmp installation file
create_tmp_install_file

# func for installing extensions
install_extenstions

# create show message function in tmp_install.sh
showMessage

# create enable user themes function in tmp_install.sh

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
	echo "showMessage \"Changing hostname...\"" >> tmp_install.sh
	echo "hostnamectl set-hostname \"${NEW_HOSTNAME}\"" >> tmp_install.sh
fi

# install gnome tweak tool

prompt_confirm "install Gnome Tweak Tool? [Y/N]"

if [ $? -eq 0 ];
then
	echo -e "\n# install gnome tweak tool" >> tmp_install.sh
	echo "showMessage \"Installing Gnome Tweak Tools...\"" >> tmp_install.sh
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
		echo "	showMessage \"Installing Google Chrome...\"" >> tmp_install.sh
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
	echo "showMessage \"Activating RPMFusion Repository...\"" >> tmp_install.sh
	echo "dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" >> tmp_install.sh
fi

# Installing VLC Media Player

prompt_confirm "install VLC Media Player? [Y/N]"

if [ $? -eq 0 ];
then
	echo -e "\n# installing VLC Media Player" >> tmp_install.sh
	echo "COUNT=$(ls /etc/yum.repos.d/ | grep -c rpmfusion)" >> tmp_install.sh
	echo -e "if [ \$COUNT -gt 0 ];\nthen" >> tmp_install.sh
	echo "	showMessage \"Installing VLC...\"" >> tmp_install.sh
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
	echo "showMessage \"Installing Docky...\"" >> tmp_install.sh
	echo "dnf -y install docky" >> tmp_install.sh
fi

# install GIMP

prompt_confirm "install GIMP? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install GIMP" >> tmp_install.sh
	echo "showMessage \"Installing GIMP...\"" >> tmp_install.sh
	echo "dnf -y install gimp" >> tmp_install.sh
fi

# install pidgin

prompt_confirm "install pidgin? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install pidgin" >> tmp_install.sh
	echo "showMessage \"Installing Pidgin...\"" >> tmp_install.sh
	echo "dnf -y install pidgin" >> tmp_install.sh
fi

# install transmission

prompt_confirm "install transmission? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install transmission" >> tmp_install.sh
	echo "showMessage \"Installing Transmission...\"" >> tmp_install.sh
	echo "dnf -y install transmission" >> tmp_install.sh
fi

# install qbittorrent

prompt_confirm "install qbittorrent? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install qbittorrent" >> tmp_install.sh
	echo "showMessage \"Installing qBittorrent...\"" >> tmp_install.sh
	echo "dnf -y install qbittorrent" >> tmp_install.sh
fi

# install VirtualBox

prompt_confirm "install VirtualBox? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install VirtualBox" >> tmp_install.sh
	echo "showMessage \"Installing VirtualBox...\"" >> tmp_install.sh
	echo "dnf -y install VirtualBox" >> tmp_install.sh
fi

# install Spotify

prompt_confirm "install Spotify? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Spotify" >> tmp_install.sh
	echo "showMessage \"Installing Spotify...\"" >> tmp_install.sh
	echo "dnf -y config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo && dnf -y install spotify-client" >> tmp_install.sh
fi

# install Steam

prompt_confirm "install Steam? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install steam" >> tmp_install.sh
	echo "showMessage \"Installing Steam...\"" >> tmp_install.sh
	echo "dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo && dnf -y install steam" >> tmp_install.sh
fi

# install Wine

prompt_confirm "install Wine? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Wine" >> tmp_install.sh
	echo "showMessage \"Installing Wine...\"" >> tmp_install.sh
	echo "dnf -y install wine" >> tmp_install.sh
fi

# install Youtube-dl

prompt_confirm "install Youtube-DL? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Youtube-dl" >> tmp_install.sh
	echo "showMessage \"Installing Youtube-dl...\"" >> tmp_install.sh
	echo "dnf -y install youtube-dl" >> tmp_install.sh
fi

# install simple scan

prompt_confirm "install Simple Scan? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install simple scan" >> tmp_install.sh
	echo "showMessage \"Installing Simple Scan...\"" >> tmp_install.sh
	echo "dnf -y install simple-scan" >> tmp_install.sh
fi

# install Fedora Media Writer

prompt_confirm "install Fedora Media Writer? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Fedora Media Writer" >> tmp_install.sh
	echo "showMessage \"Installing Fedora Media Writer...\"" >> tmp_install.sh
	echo "dnf -y install mediawriter" >> tmp_install.sh
fi

# install gnome music player

prompt_confirm "install Gnome Music Player? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Gnome Music Player" >> tmp_install.sh
	echo "showMessage \"Installing Gnome Media Player...\"" >> tmp_install.sh
	echo "dnf -y install gnome-music" >> tmp_install.sh
fi

# install guake

prompt_confirm "install Guake Terminal? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Guake" >> tmp_install.sh
	echo "showMessage \"Installing Guake Terminal...\"" >> tmp_install.sh
	echo "dnf -y install guake" >> tmp_install.sh
fi


# install sublime text

prompt_confirm "install Sublime Text? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install sublime-text" >> tmp_install.sh
	echo "showMessage \"Installing Sublime Text...\"" >> tmp_install.sh
	echo "rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg && dnf -y config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo && dnf -y install sublime-text" >> tmp_install.sh
fi

# install vs code

prompt_confirm "install Visual Studio Code? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Visual Studio Code" >> tmp_install.sh
	echo "showMessage \"Installing Visual Studio Code...\"" >> tmp_install.sh
	echo "rpm --import https://packages.microsoft.com/keys/microsoft.asc && sh -c 'echo -e \"[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\" > /etc/yum.repos.d/vscode.repo' && dnf -y check-update && dnf -y install code" >> tmp_install.sh
fi

# install paper-icon-theme and paper-gtk-theme

prompt_confirm "install Paper-icon-theme and paper-gtk-theme? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install Paper-icon-theme" >> tmp_install.sh
	echo "showMessage \"Installing Paper Theme...\"" >> tmp_install.sh
	echo "dnf -y config-manager --add-repo https://download.opensuse.org/repositories/home:snwh:paper/Fedora_25/home:snwh:paper.repo && dnf -y install paper-icon-theme && dnf -y install paper-gtk-theme && enable_user_themes" >> tmp_install.sh
fi

# install Numix theme

prompt_confirm "install Numix Theme? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install numix theme" >> tmp_install.sh
	echo "showMessage \"Installing Numix Theme...\"" >> tmp_install.sh
	echo "dnf -y install numix-gtk-theme numix-icon-theme numix-icon-theme-circle && enable_user_themes" >> tmp_install.sh
fi

# Extensions

# dash to dock
prompt_confirm "install Dash to Dock? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install dash to dock" >> tmp_install.sh
	echo "showMessage \"Installing Dash to Dock extention...\"" >> tmp_install.sh
	echo "install_extension \"${DASH_TO_DOCK}\" \"${DASH_TO_DOCK_UUID}\"" >> tmp_install.sh
fi

# dynamic top bar
prompt_confirm "install Dynamic top Bar? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install dynamic top bar" >> tmp_install.sh
	echo "showMessage \"Installing Dynamic Top Bar extention...\"" >> tmp_install.sh
	echo "install_extension \"${DYNAMIC_TOP_BAR}\" \"${DYNAMIC_TOP_BAR_UUID}\"" >> tmp_install.sh
fi

# install net speed
prompt_confirm "install NetSpeed? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install net speed" >> tmp_install.sh
	echo "showMessage \"Installing NetSpeed extention...\"" >> tmp_install.sh
	echo "install_extension \"${NET_SPEED}\" \"${NET_SPEED_UUID}\"" >> tmp_install.sh
fi

# alternate tab
prompt_confirm "install Alternate Tab? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install alternate tab" >> tmp_install.sh
	echo "showMessage \"Installing Alternate Tab extention...\"" >> tmp_install.sh
	echo "install_extension \"${ALTENATE_TAB}\" \"${ALTENATE_TAB_UUID}\"" >> tmp_install.sh
fi

# install workspace to dock
prompt_confirm "install Workspace to Dock? [Y/N]"
if [ $? -eq 0 ];
then
	echo -e "\n# install workspace to dock" >> tmp_install.sh
	echo "showMessage \"Installing Workspace to Dock extention...\"" >> tmp_install.sh
	echo "install_extension \"${WORKSPACE_TO_DOCK}\" \"${WORKSPACE_TO_DOCK_UUID}\"" >> tmp_install.sh
fi

chmod +x tmp_install.sh

echo -e "\n# enable video play and file thumbnails
dnf -y install gstreamer1-libav" >> tmp_install.sh

echo -e "\n# install GNOME Shell integration 
dnf -y install chrome-gnome-shell" >> tmp_install.sh

sh ./tmp_install.sh

# remove temp installation file
rm tmp_install.sh
