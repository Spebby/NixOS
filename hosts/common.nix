# /hosts/common.nix

{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home-manager.backupFileExtension = "backup";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    home-manager
    openssl
    wget

    gnome-keyring
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
