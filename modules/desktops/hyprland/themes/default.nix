{
  my.desktops._.hyprland._.themes._.default =
    {
      lib,
      cfg,
      waybarEnabled ? true,
      wofiEnabled ? true,
      swayncEnabled ? true,
    }:
    {
      inherit (cfg) env;

      monitor = "$mainMonitor,${cfg.monitorResolution},auto,${cfg.monitorScale}";
      "$mainMonitor" = cfg.mainMonitor;
      "$mainMod" = cfg.mainMod;
      "$terminal" = cfg.terminal;
      "$fileManager" = cfg.fileManager;
      "$menu" = cfg.menu;

      xwayland.force_zero_scaling = true;
      exec-once = (if waybarEnabled then [ "waybar" ] else [ ]) ++ [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet"
      ];

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
        blur.enabled = false;
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        shadow.enabled = false;
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

      input = {
        kb_layout = "us";
        kb_options = "grp:caps_toggle";
        repeat_rate = 60;
        repeat_delay = 400;
        touchpad.natural_scroll = false;
        sensitivity = 0;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_invert = false;
        workspace_swipe_forever = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

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

      bind = [
        "$mainMod,       Q, exec, hypr-kill-or-hide-steam"
        "$mainMod CTRL,  ESCAPE, exit,"
        "$mainMod,       L, exec, loginctl lock-session"
        "$mainMod,       C, exec, hyprpicker -an"
        "$mainMod,       B, fullscreen, 1"
      ]
      ++ lib.optionals swayncEnabled [ "$mainMod,       N, exec, swaync-client -t" ]
      ++ [
        ", Print, exec, grimblast --notify --freeze copysave area | swappy -f -"
        "$mainMod,       RETURN, exec, $terminal"
      ]
      ++ lib.optionals wofiEnabled [ "$mainMod,       R, exec, $menu --show drun" ]
      ++ [
        "$mainMod,       D, exec, $fileManager"
        "$mainMod,       E, exec, bemoji -cn"
        "$mainMod,       V, exec, cliphist list | $menu --dmenu | cliphist decode | wl-copy"
        "$mainMod,       F, togglefloating,"
        "$mainMod,       G, pin,"
        "$mainMod,       H, togglesplit,"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod SHIFT, left,  swapwindow, l"
        "$mainMod SHIFT, right, swapwindow, r"
        "$mainMod SHIFT, up,    swapwindow, u"
        "$mainMod SHIFT, down,  swapwindow, d"
        "$mainMod CTRL, left,  resizeactive, -60 0"
        "$mainMod CTRL, right, resizeactive,  60 0"
        "$mainMod CTRL, up,    resizeactive,  0 -60"
        "$mainMod CTRL, down,  resizeactive,  0  60"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod, P, togglespecialworkspace, popupterm"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod CTRL, right, workspace, e+1"
        "$mainMod CTRL, left, workspace, e-1"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, P, movetoworkspace, special:popupterm"
        "$mainMod, SPACE, layoutmsg, swapwithmaster"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        "SHIFT,XF86AudioRaiseVolume,  exec, brightnessctl s 10%+"
        "SHIFT,XF86AudioLowerVolume,  exec, brightnessctl s 10%-"
        "$mainMod, bracketright, exec, brightnessctl s 10%+"
        "$mainMod, bracketleft,  exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioNext,  exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay,  exec, playerctl play-pause"
        ", XF86AudioPrev,  exec, playerctl previous"
      ];

      windowrulev2 = [
        "bordersize 0, floating:0, onworkspace:w[t1]"
        "float,class:(mpv)|(imv)|(showmethekey-gtk)"
        "float, class:pavucontrol"
        "center, class:pavucontrol"
        "size 1200 400, class:pavucontrol"
        "move 990 60,size 900 170,pin,noinitialfocus,class:(showmethekey-gtk)"
        "noborder,nofocus,class:(showmethekey-gtk)"
        "bordercolor rgba(89ff89ee) rgba(c4ff89ee) 45deg rgba(89ff89bb) rgba(003b00bb) 45deg,pinned:1"
        "bordersize 1, pinned:1"
        "workspace name:unity silent, class:(Unity)"
        "workspace name:game,  class:^(^gamescope$|^steam_app_.*$)"
        "workspace name:daw, class:(fl64.exe)"
        "noanim, title:^(gamescope)$"
        "noblur, title:^(gamescope)$"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur,  class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
        "allowsinput, class:^(discord)$, xwayland:0"
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
}
