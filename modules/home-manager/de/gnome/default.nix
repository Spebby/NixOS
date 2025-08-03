# /modules/home-mananger/de/gnome/default.nix

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.gnome;
in
{
  options.gnome = with lib; {
    enable = mkOption {
      type = types.bool;
      # Would be good to auto-set this based on the computer's settings
      default = false;
      description = "personal gnome configuration";
    };
  };

  imports = [ ./dconf.nix ];
  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (import ./overlays/simple-weather.nix)
      (import ./overlays/dconf2nix.nix)
    ];

    home.packages = with pkgs; [
      gnome-tweaks

      # Visuals
      gnomeExtensions.app-menu-is-back
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.compact-top-bar
      gnomeExtensions.hibernate-status-button
      gnomeExtensions.media-controls
      #gnomeExtensions.simple-weather

      # Productivity
      gnomeExtensions.forge
      gnomeExtensions.vitals

      # Functionality
      gnomeExtensions.xwayland-indicator

      # nix specific gnome utils
      dconf2nix
    ];
  };
}
