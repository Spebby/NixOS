# /hosts/rosso/configuration.nix

{
  pkgs,
  lib,
  stateVersion,
  hostname,
  nixos-hardware,
  ...
}:

{
  networking.hostName = hostname;
  system.stateVersion = stateVersion;
  nixpkgs.config.cudaSupport = true;

  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../common.nix # Common to hosts
    ../../nixos/modules # Global modules
    nixos-hardware.nixosModules.lenovo-legion-16ach6h-nvidia
    ../../users/thom.nix
    ../../users/max.nix
  ];

  environment = {
    systemPackages = [
      pkgs.home-manager
      pkgs.bottles
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  # Hyperland Specific
  programs.hyprland = {
    enable = true;

    # These two are sometimes nice but I don't want em' for now
    # withUWSM = true;
    # xwayland.enable = false;
  };
  security.pam.services.hyprlock = { };

  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    sharedModules = [ { home.stateVersion = stateVersion; } ];
  };

  services.getty = {
    greetingLine = "moo";
    # autoLoginUser = user;
  };
}
