# /hosts/common.nix

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    home-manager
    openssl
    wget
  ];

  programs.zsh.enable = true;

  services = {
    flatpak.enable = true;
    gvfs.enable = true; # Mount, Trash, etc
    tumbler.enable = true; # Thumbnail support for images
  };

  security.doas = {
    enable = true;
    extraRules = [
      {
        keepEnv = true;
        groups = [ "wheel" ];
        noPass = true;
      }
    ];
  };
}
