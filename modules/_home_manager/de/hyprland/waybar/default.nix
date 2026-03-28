{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.hyprland;

  swayncClient = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
  playerctl = lib.getExe pkgs.playerctl;
  jq = lib.getExe pkgs.jq;

  scripts = import ./scripts.nix {
    inherit pkgs playerctl jq;
  };

  waybarSettings = import ./settings.nix {
    inherit
      pkgs
      swayncClient
      playerctl
      jq
      ;
    inherit (scripts) queryMediaScript;
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      networkmanagerapplet
      wttrbar
    ];

    programs.waybar = {
      enable = true;
      style = ./style.css;

      settings = waybarSettings;
    };

    home.file = {
      ".config/waybar/power_menu.xml".source = ./power_menu.xml;

      ".config/waybar/colours.css".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/stylix/colours.css";
    };
  };
}
