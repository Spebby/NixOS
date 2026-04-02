{ config, lib, ... }:

let
  cfg = config.my.desktops._.hyprland.home;
  shellEnabled = cfg.shell.enable;
  wofiEnabled =
    let
      v = cfg.components.wofi.enable;
    in
    if v == null then !shellEnabled else v;
in
{
  my.desktops._.hyprland.provides.wofi.homeManager = {
    config = lib.mkIf (cfg.enable && wofiEnabled) {
      programs.wofi = {
        enable = true;
        settings = {
          allow_markup = true;
          allow_images = true;
          width = 450;
          height = 500;
        };
      };

      home.file = {
        ".config/wofi.css".source = ./_wofi/style.css;
        ".config/wofi/colours.css".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/stylix/colours.css";
      };
    };
  };
}
