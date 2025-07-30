{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

let
  cfg = config.hyprland;
in
{
  imports = [ inputs.hyprland-unity-fix.nixosModules.hyprlandUnityFixModule ];
  config = lib.mkIf cfg.enable {
    hyprlandUnityFix = {
      enable = true;
      configRules = [

      ];
    };

    home.packages = with pkgs; [
      kitty
      xdotool
      jq
      (writeShellScriptBin "hypr-kill-or-hide-steam" ''
        if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
            xdotool getactivewindow windowunmap
        else
            hyprctl dispatch killactive ""
        fi
      '')
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings = {
        inherit (cfg) env;

        # hpyrwiki.../Configuration/Variables
        general = {
          gaps_in = 5;
          gaps_out = 9;

          border_size = 2;

          "col.active_border" = "rgba(d65d0eff) rgba(98971aff) 45deg";
          "col.inactive_border" = "rgba(3c3836ff)";

          resize_on_border = true;

          allow_tearing = false;
          layout = "master";
        };

        decoration = {
          blur = {
            enabled = false;
            #size = 3;
            #passes = 1;
            #new_optimizations = one;
          };

          rounding = 0;
          #drop_shadow = false;
          #shadow_range = 4;
          #shadow_render_power = 3;
          #"col.shadow" = "rgba(1a1a1aee)";

          active_opacity = 1.0;
          inactive_opacity = 0.9;

          shadow = {
            enabled = false;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows,    1, 2, myBezier"
            "windowsIn,  1, 7, default, slide, 80%"
            "windowsOut, 1, 7, default, slide, 85%"
            "border, 1, 2, default"
            "borderangle, 1, 8, default"
            "fade, 1, 2, default"
            "workspaces, 1, 6, default"
            "specialWorkspace, 1, 3, default, slidefadevert, 95%"
          ];
        };

        # hpyrwiki.../Configuration/Variables/<M-C-F2> for all categories
        input = {
          kb_layout = "us";
          kb_options = "grp:caps_toggle";

          repeat_rate = 60;
          repeat_delay = 400;

          touchpad = {
            natural_scroll = false;
          };

          sensitivity = 0; # -1.0 - 1.0... 0 means no modification.
        };

        # hyprwiki.../Configuring/Variables/
        gestures = {
          workspace_swipe = true;
          workspace_swipe_invert = false;
          workspace_swipe_forever = true;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # hyprwiki.../Configuring/Master-Layout
        master = {
          new_status = "slave";
          new_on_top = true;
          mfact = 0.5;

          special_scale_factor = 0.8;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          enable_swallow = true;
          swallow_regex = ".*($terminal)";
        };

        windowrulev2 = [
          "bordersize 0, floating:0, onworkspace:w[t1]"

          "float,class:(mpv)|(imv)|(showmethekey-gtk)"

          # Volume Manager
          "float, class:pavucontrol"
          "center, class:pavucontrol"
          "size 1200 400, class:pavucontrol"

          # Scratch Notes
          "center, class:^(scratch-note)$"
          "float, class:^(scratch-note)$"

          "move 990 60,size 900 170,pin,noinitialfocus,class:(showmethekey-gtk)"
          "noborder,nofocus,class:(showmethekey-gtk)"

          # Borders for different state
          "bordercolor rgba(89ff89ee) rgba(c4ff89ee) 45deg rgba(89ff89bb) rgba(003b00bb) 45deg,pinned:1"
          # Set pinned windows to mint-ish border. Darker mint on inactive.
          "bordersize 1, pinned:1" # Give it a smaller border too

          # Special Workspaces
          "workspace name:unity silent, class:(Unity)"
          "workspace name:game,  class:^(^gamescope$|^steam_app_.*$)"
          "workspace name:daw, class:(fl64.exe)"

          "noanim, title:^(gamescope)$"
          "noblur, title:^(gamescope)$"

          # Popup term rules
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

          "opacity 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur,  class:^(xwaylandvideobridge)$"
          "nofocus, class:^(xwaylandvideobridge)$"

          # Fix for Discord not taking keybinds JUST KIDDING THIS DONT WORK
          "allowsinput, class:^(discord)$, xwayland:0"

          # Make file manager start floating
          "float,         class:^($fileManager)$"
          "center,        class:^($fileManager)$"
          "movecursor,    class:^($fileManager)$"
          "size 1200 800, class:^($fileManager)"
        ];

        workspace = [
          "name:unity, id:100"
          "name:game, id:101"
          "name:daw, id:102"
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
          "special:popupterm,on-created-empty:$terminal"
        ];
      };
    };
  };
}
