#!/usr/bin/env bash

set -x

ROOT=/

while [ "$#" -gt 1 ]; do
    case $1 in
        --rebuild)
            REBUILD=yes
            ;;
        --root)
            ROOT=$2
            ;;
    esac
    shift
done

sudo cp configuration.nix /etc/nixos/configuration.nix
if [ ! -z ${REBUILD} ]; then
    sudo nixos-rebuild switch
fi
sudo -u dylan mkdir -p ${ROOT}/home/dylan/.config/hypr
sudo -u dylan mkdir -p ${ROOT}/home/dylan/.config/waybar
sudo -u c mkdir -p ${ROOT}/home/c/.config/hypr
sudo -u c mkdir -p ${ROOT}/home/c/.config/waybar
sudo -u dylan cp hyprland.conf ${ROOT}/home/dylan/.config/hypr/hyprland.conf
sudo -u dylan cp waybar.conf ${ROOT}/home/dylan/.config/waybar/config.jsonc
sudo -u dylan cp gitconfig ${ROOT}/home/dylan/.gitconfig
sudo -u dylan cp vimrc ${ROOT}/home/dylan/.vimrc
sudo -u dylan curl -fLo ${ROOT}/home/dylan/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo -u c cp hyprland.conf ${ROOT}/home/c/.config/hypr/hyprland.conf
sudo -u c cp waybar.conf ${ROOT}/home/c/.config/waybar/config.jsonc
sudo -u c cp gitconfig ${ROOT}/home/c/.gitconfig
sudo -u c cp vimrc ${ROOT}/home/c/.vimrc
sudo -u c curl -fLo ${ROOT}/home/c/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo kill -SIGUSR2 $(pgrep waybar)
