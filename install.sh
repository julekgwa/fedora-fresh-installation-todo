#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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

# update system
dnf -y update

# enable video play and file thumbnails
dnf -y install gstreamer1-libav

# install GNOME Shell integration 
dnf -y install chrome-gnome-shell