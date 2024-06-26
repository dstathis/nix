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

  # Printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
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
    brave
    brightnessctl
    dunst
    firefox # Good to have a backup
    git
    gnome.gnome-screenshot
    gnupg
    killall
    kitty
    libreoffice
    networkmanagerapplet
    nwg-displays
    parted
    pavucontrol
    pipewire
    playerctl
    polkit-kde-agent
    procps
    python3
    spotify
    vim
    waybar
    wget
    wireplumber
    wlr-randr
    wofi
    xdg-desktop-portal-hyprland
  ];

  security.sudo.wheelNeedsPassword = false;

  system.copySystemConfiguration = true;

  # Original install version. Set accordingly and never change
  system.stateVersion = "24.05";

}
