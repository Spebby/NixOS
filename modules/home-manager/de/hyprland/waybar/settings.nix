{
  pkgs,
  swayncClient,
  playerctl,
  jq,
  queryMediaScript,
}:

{
  mainBar = {
    layer = "top";
    position = "top";
    height = 30;
    modules-left = [
      "hyprland/workspaces"
      "custom/media-playing"
    ];

    modules-right = [
      "hyprland/submap"
      "custom/weather"
      "pulseaudio"
      "battery"
      "clock"
      "custom/notification"
      "tray"
    ];

    "hyprland/workspaces" = {
      disable-scroll = true;
      show-special = true;
      special-visible-only = true;
      all-outputs = false;
      format = "{icon}";
      format-icons = {
        "magic" = "";
        "unity" = "";
        "game" = "";
        "daw" = "";
        "popupterm" = "";
      };
    };

    "hyprland/submap" = {
      format = " {}";
      max-length = 8;
      tooltip = false;
      always-on = false;
    };

    "hyprland/language" = {
      format-en = "🇬🇧";
      format-nl = "🇳🇱";
      format-fr = "🇫🇷";
      min-length = 5;
      tooltip = false;
    };

    "custom/weather" = {
      format = " {} ";
      tooltip = true;
      exec = "wttrbar --ampm --lang en --location \"Santa Cruz\" --date-format \"%A, %d/%m\"";
      return-type = "json";
      interval = 300;
    };

    "pulseaudio" = {
      format = "{icon} {volume}%";
      format-bluetooth = "{icon} {volume}% ";
      format-muted = "";
      format-icons = {
        "headphones" = "";
        "handsfree" = "";
        "headset" = "";
        "phone" = "";
        "portable" = "";
        "car" = "";
        "default" = [
          ""
          ""
        ];
      };
      on-click = "pavucontrol";
    };

    "custom/power" = {
      format = "⏻";
      tooltip = false;
      menu = "on-click";
      menu-file = ".config/waybar/power_menu.xml";
      menu-actions = {
        shutdown = "poweroff";
        reboot = "reboot";
        suspend = "systemctl suspend";
        hibernate = "systemctl hibernate";
      };
    };

    "battery" = {
      states = {
        warning = 30;
        critical = 1;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-alt = "{time} {icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
    };

    "clock" = {
      format = "{:%D %H:%M}";
      format-alt = "{:%A, %B %d at %R}";
    };

    "tray" = {
      icon-size = 14;
      spacing = 1;
    };

    "custom/media-playing" = {
      tooltip = false;
      format = "{icon} {}";
      format-icons = {
        spotify = "";
        chromium = "";
        cider = "󰝚";
        firefox = "";
        vlc = "";
        default = "";
      };

      return-type = "json";
      exec-if = "which ${playerctl}";
      exec = queryMediaScript;

      on-click = ''
        bash -c '
          player_priority="cider, spotify, vlc, firefox, chromium"
          active=$(playerctl -l \
                    | tr "," "\n" \
                    | grep -E "^(cider|spotify|vlc|firefox|chromium)$" \
                    | head -n1)
          if [ -n "$active" ]; then
            case "$active" in
              cider)     cider         ;;
              spotify)   spotify       ;;
              vlc)       vlc           ;;
              firefox)   firefox       ;;
              chromium)  chromium      ;;
            esac &
          fi
        '
      '';
    };

    "custom/notification" = {
      tooltip = false;
      format = "{icon}";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>";
        none = "";
        dnd-notification = "󰂛<span foreground='red'><sup></sup></span>";
        dnd-none = "󰂛";
        inhibited-notification = "<span foreground='red'><sup></sup></span>";
        inhibited-none = "";
        dnd-inhibited-notification = "󰂛<span foreground='red'><sup></sup></span>";
        dnd-inhibited-none = "󰂛";
      };
      return-type = "json";
      exec-if = "which ${swayncClient}";
      exec = "${swayncClient} -swb";
      on-click = "${swayncClient} -t -sw";
      on-click-right = "${swayncClient} -d -sw";
      escape = true;
    };
  };
}
