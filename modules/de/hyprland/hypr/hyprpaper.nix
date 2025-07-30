{ config, lib, ... }:

let
  cfg = config.hyprland;
in
{
  # Wallpaper is configured in ../stylix.nix
  services.hyprpaper = lib.mkIf cfg.enable { enable = true; };
}
