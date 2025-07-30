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
  imports = [ ./dconf.nix ];
  options.gnome = with lib; {
    enable = mkOption {
      type = types.bool;
      # Would be good to auto-set this based on the computer's settings
      default = false;
      description = "personal gnome configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-tweaks

      # For gnome
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.burn-my-windows
      gnomeExtensions.hibernate-status-button
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.vitals

      # nix specific gnome utils
      dconf2nix
    ];
  };
}
