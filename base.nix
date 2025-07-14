{ config, lib, pkgs, ... }:


let
  unstable = import <nixos-unstable> {};
in {
  # Boot Config
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  time.timeZone = "{{ timezone }}";
  services.openssh.enable = true;

  # Window Manager
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Users
  users.users.dylan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "lxd" "libvirtd" "docker" ];
  };
  users.users.c = {
    isNormalUser = true;
    extraGroups = [ "wheel" "lxd" "libvirtd" "docker" ];
  };

  # Printing
  services.printing.enable = true;
  services.printing.browsedConf = ''
  BrowseDNSSDSubTypes _cups,_print
  BrowseLocalProtocols all
  BrowseRemoteProtocols all
  CreateIPPPrinterQueues All
  BrowseProtocols all
  '';
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
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.vim;
  };
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
  };

  # VMs
  virtualisation.lxd.enable = true;
  # revert to stable when fixed: https://github.com/NixOS/nixpkgs/issues/422385#issuecomment-3049980409
  virtualisation.lxd.package = unstable.lxd-lts;
  virtualisation.docker.enable = true;
  networking.firewall.trustedInterfaces = [ "lxdbr0" ];
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    appimage-run
    blueman
    brave
    brightnessctl
    cifs-utils
    discord
    drawing
    drawio
    dunst
    element-desktop
    firefox # Good to have a backup
    gh
    git
    gnome-screenshot
    gnupg
    go
    grim
    joplin-desktop
    unstable.juju
    killall
    kitty
    kubectl
    libreoffice
    mosh
    networkmanagerapplet
    nmap
    unstable.nwg-displays
    parted
    pavucontrol
    pipewire
    playerctl
    hyprpolkitagent
    procps
    python3
    ripgrep
    signal-desktop
    slurp
    spotify
    swaylock
    unrar
    unstable.uv
    vim
    vlc
    waybar
    wget
    wireplumber
    wlr-randr
    wofi
    xdg-desktop-portal-hyprland

    # PIA https://github.com/pia-foss/manual-connections
    curl
    jq
    wireguard-tools
  ];

  services.tailscale.enable = true;

  fonts.packages = with pkgs; [
    font-awesome
  ];

  security.sudo.wheelNeedsPassword = false;

  system.copySystemConfiguration = true;

  # Original install version. Set accordingly and never change
  system.stateVersion = "24.05";

}
