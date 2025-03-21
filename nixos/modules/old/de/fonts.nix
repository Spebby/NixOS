# /etc/nixos/de/hyprland.nix

{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome
    nerdfonts
  ];
}
