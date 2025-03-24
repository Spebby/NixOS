{ pkgs, config, hyprland, ... }:

let
	terminal = "alacritty";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      env = [
        # Hint Electron apps to use Wayland
        "NIXOS_OZONE_WL, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "QT_QPA_PLATFORM, wayland"
        "XDG_SCREENSHOTS_DIR, $HOME/screens"
      ];

      monitor = "eDP-1,2560x1600@165,0x0,1.33";
      "$mainMod" = "SUPER";
      "$terminal" = "${terminal}";
      "$fileManager" = "$terminal -e sh -c 'ranger'";
      "$menu" = "wofi";

			#	  "$idleBrightness" = "idleBrightness.sh";
      exec-once = [
        "waybar"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
				#		"swayidle -w timeout 200 $idleBrightness 'startIdle' resume $idleBrightness 'endIdle'"
				#		"swayidle -w timeout 600 $idleBrightness 'finalIdle' resume $idleBrightness 'endIdle'"

		# Other applets/daemons go here
	  ];

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

        active_opacity   = 1.0;
        inactive_opacity = 0.9;

        shadow = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;
		bezier  = "myBezier, 0.05, 0.9, 0.1, 1.05";

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

	  # hpyrwiki.../Configuration/Variables/<M-C-F2> for all catagories
      input = {
        kb_layout = "us";
        kb_options = "grp:caps_toggle";

		repeat_rate  = 60;
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
        workspace_swipe_forever	= true;
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
		swallow_regex = ".*(${terminal})";
      };

      windowrulev2 = [
        "bordersize 0, floating:0, onworkspace:w[t1]"

        "float,class:(mpv)|(imv)|(showmethekey-gtk)"
        "move 990 60,size 900 170,pin,noinitialfocus,class:(showmethekey-gtk)"
        "noborder,nofocus,class:(showmethekey-gtk)"

		# This is a neat idea, but I'm probably only going to
		# reserve this for something like a VM or steam games.
		#"workspace 3,class:(obsidian)"
		#"workspace 3,class:(zathura)"
		#"workspace 4,class:(com.obsproject.Studio)"
		#"workspace 5,class:(telegram)"
		#"workspace 5,class:(vesktop)"
		#"workspace 6,class:(teams-for-linux)"

		# Popup term rules
		"bordersize 0, opacity 0.8 override, onworkspace:w[popupterm], class:popupterm"

        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
      ];

      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
		"special:popupterm,on-created-empty:${terminal}"
      ];
    };
  };
}
