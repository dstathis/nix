{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Boot Config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "enterprise";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Athens";

  # Window Manager
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Users
  users.users.dylan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "lxd" "libvirtd" ];
  };
  users.users.c = {
    isNormalUser = true;
    extraGroups = [ "wheel" "lxd" "libvirtd" ];
  };

  # Apps
  nixpkgs.config.allowUnfree = true;
  programs.hyprland.enable = true;
  programs.virt-manager.enable = true;
  programs.steam.enable = true;

  # VMs
  virtualisation.lxd.enable = true;
  virtualisation.libvirtd.enable = true;
  networking.firewall.trustedInterfaces = [ "lxdbr0" ];

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    brave
    firefox # Good to have a backup
    kitty
    wofi
    waybar
    dunst
    pipewire
    wireplumber
    xdg-desktop-portal-hyprland
    polkit-kde-agent
    nwg-displays
    wlr-randr
    networkmanagerapplet
    pavucontrol
    killall
    parted
    procps
    gnupg
    python3
  ];

  security.sudo.wheelNeedsPassword = false;

  system.copySystemConfiguration = true;

  # Original install version. Set accordingly and never change
  system.stateVersion = "24.05";

}
