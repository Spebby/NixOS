{
  self',
  pkgs,
  lib,
  ...
}:
{
  my.desktops._.hyprland.provides.hypr.homeManager =
    { lib, config, ... }:
    let
      cfg = config.my.desktops._.hyprland.home;
      shellEnabled = cfg.shell.enable;
      hyprEnabled =
        let
          v = cfg.components.hypr.enable;
        in
        if v == null then true else v;
      waybarEnabled =
        let
          v = cfg.components.waybar.enable;
        in
        if v == null then !shellEnabled else v;
      wofiEnabled =
        let
          v = cfg.components.wofi.enable;
        in
        if v == null then !shellEnabled else v;
      swayncEnabled =
        let
          v = cfg.components.swaync.enable;
        in
        if v == null then !shellEnabled else v;

      hyprKillOrHideSteam = pkgs.writeShellScriptBin "hypr-kill-or-hide-steam" ''
        if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
          xdotool getactivewindow windowunmap
        else
          hyprctl dispatch killactive ""
        fi
      '';

      hyprSettings = cfg.theme {
        inherit
          lib
          cfg
          waybarEnabled
          wofiEnabled
          swayncEnabled
          ;
      };

      hyprPackage =
        if cfg.package != null then
          cfg.package
        else if cfg.useWrapper then
          self'.packages.myHyprland
        else
          null;
    in
    {
      config = lib.mkIf (cfg.enable && hyprEnabled) {
        home.packages = with pkgs; [
          kitty
          xdotool
          jq
          brightnessctl
          hyprKillOrHideSteam
          bemoji
          cliphist
          hyprpicker
          hyprshade
          grimblast
          swappy
          wev
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          package = hyprPackage;
          portalPackage = null;
          systemd.enable = true;
          settings = hyprSettings;
        };

        services.hypridle = lib.mkIf (!shellEnabled) {
          enable = true;
          settings = {
            general = {
              before_sleep_cmd = ''
                loginctl lock-session
              '';
              after_sleep_cmd = ''
                hyprctl dispatch dpms on
              '';
              ignore_dbus_inhibit = false;
              lock_cmd = "pidof hyprlock || hyprlock";
            };

            listener = [
              {
                timeout = 120;
                on-timeout = "brightnessctl -s set 30 && brightnessctl -sd set rgb:kbd_backlight set 0";
                on-resume = "brightnessctl -r && brightnessctl -rd rgb:kbd_backlight";
              }
              {
                timeout = 180;
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 240;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };

        programs.hyprlock = lib.mkIf (!shellEnabled) {
          enable = true;
          settings = {
            general = {
              disable_loading_bar = true;
              grace = 5;
              hide_cursor = true;
              no_fade_in = false;
            };

            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 4;
              }
            ];

            input-field = [
              {
                monitor = "";
                halign = "center";
                valign = "bottom";
                position = "0, 60";
                size = "250, 50";
                outline_thickness = 3;
                dots_size = 0.2;
                dots_spacing = 1.00;
                dots_center = true;
                font_color = "rgb(235, 219, 178)";
                inner_color = "rgb(40, 40, 40)";
                outer_color = "rgb(60, 56, 54)";
                fade_on_empty = true;
                hide_input = false;
                placeholder_text = "<i>Password...</i>";
                shadow_passes = 1;
              }
            ];
          };
        };

        services.hyprpaper = lib.mkIf (!shellEnabled) { enable = true; };
      };
    };
}
