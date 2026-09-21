{ config, lib, pkgs, ... }:


let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # Boot Config
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  time.timeZone = "{{ timezone }}";
  services.openssh.enable = true;

  # Window Manager
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Users
  users.users.dylan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" ];
  };
  users.users.c = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" ];
  };

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
   # browsedConf = ''
   # BrowseDNSSDSubTypes _cups,_print
   # BrowseLocalProtocols all
   # BrowseRemoteProtocols all
   # CreateIPPPrinterQueues All
   # BrowseProtocols all
   # '';
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # VPN
  services.expressvpn.enable = true;

  # Apps
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
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

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
    };
  };

  # VMs
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    appimage-run
    blueman
    brave
    brightnessctl
    cifs-utils
    claude-code
    cowsay
    discord
    drawing
    drawio
    dunst
    element-desktop
    expressvpn
    gcc
    gh
    git
    gnome-screenshot
    gnumake
    gnupg
    go
    grim
    joplin-desktop
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
    unzip
    unstable.uv
    vim
    vlc
    unstable.vscode
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
