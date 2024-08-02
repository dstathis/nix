{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./base.nix
    ];

  networking.hostName = "enterprise";

}
