# /etc/nixos/de/hyprland.nix

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    doas
    git
    github-cli
    cmake
    kitty
    foot
    bat
    eza
    htop
    neofetch
    neovim
    tlp
    yazi
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    ripgrep
    unzip
  ];
}
