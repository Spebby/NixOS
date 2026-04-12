{ pkgs, lib, ... }:
{
  my.desktops._.hyprland.provides.waybar.homeManager =
    { lib, config, ... }:
    let
      cfg = config.my.desktops._.hyprland.home;
      shellEnabled = cfg.shell.enable;
      waybarEnabled =
        let
          v = cfg.components.waybar.enable;
        in
        if v == null then !shellEnabled else v;

      swayncClient = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
      playerctl = lib.getExe pkgs.playerctl;
      jq = lib.getExe pkgs.jq;

      scripts = import ./_waybar/scripts.lib.nix { inherit pkgs playerctl jq; };

      waybarSettings = import ./_waybar/settings.lib.nix {
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
      config = lib.mkIf (cfg.enable && waybarEnabled) {
        home.packages = with pkgs; [
          networkmanagerapplet
          wttrbar
        ];

        programs.waybar = {
          enable = true;
          style = ./_waybar/style.css;
          settings = waybarSettings;
        };

        home.file = {
          ".config/waybar/power_menu.xml".source = ./_waybar/power_menu.xml;
          ".config/waybar/colours.css".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/stylix/colours.css";
        };
      };
    };
}
