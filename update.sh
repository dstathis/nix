#!/usr/bin/env bash

set -x

ROOT=/

sudo cp configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo mkdir -p ${ROOT}/home/dylan/.config/hypr
sudo mkdir -p ${ROOT}/home/dylan/.config/waybar
sudo mkdir -p ${ROOT}/home/c/.config/hypr
sudo mkdir -p ${ROOT}/home/c/.config/waybar
sudo cp hyprland.conf ${ROOT}/home/dylan/.config/hypr/hyprland.conf
sudo cp waybar.conf ${ROOT}/home/dylan/.config/waybar/config.jsonc
sudo cp hyprland.conf ${ROOT}/home/c/.config/hypr/hyprland.conf
sudo cp waybar.conf ${ROOT}/home/c/.config/waybar/config.jsonc
sudo chown dylan:users ${ROOT}/home/dylan/.config/hypr/hyprland.conf
sudo chown dylan:users ${ROOT}/home/dylan/.config/waybar/config.jsonc
sudo chown c:users ${ROOT}/home/c/.config/hypr/hyprland.conf
sudo chown c:users ${ROOT}/home/c/.config/waybar/config.jsonc
sudo kill -SIGUSR2 $(pgrep waybar)
