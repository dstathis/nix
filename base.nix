{ config, lib, pkgs, ... }:


let
  unstable = import <nixos-unstable> {};
in {
  # Boot Config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://github.com/tailscale/tailscale/issues/13863
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "90gS946ImSxBZDTLEHY54TpVHbr/NruQ1jRqsWq3GpU=";
      };
      version = "6.6.56";
      modDirVersion = "6.6.56";
    };
  });

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
    defaultEditor = true;
    package = pkgs.vim;
  };
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
  };

  # VMs
  virtualisation.lxd.enable = true;
  virtualisation.docker.enable = true;
  networking.firewall.trustedInterfaces = [ "lxdbr0" ];
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    blueman
    brave
    brightnessctl
    cifs-utils
    discord
    drawio
    dunst
    element-desktop
    firefox # Good to have a backup
    gh
    git
    gnome.gnome-screenshot
    gnupg
    grim
    joplin-desktop
    unstable.juju
    killall
    kitty
    kubectl
    libreoffice
    networkmanagerapplet
    nmap
    unstable.nwg-displays
    parted
    pavucontrol
    pipewire
    playerctl
    polkit-kde-agent
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

    # NZB
    nzbget
    radarr
    sonarr

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
