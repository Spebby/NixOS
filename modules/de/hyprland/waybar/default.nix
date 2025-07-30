{
  pkgs,
  lib,
  config,
  ...
}:

let
  swayncClient = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
  playerctl = lib.getExe pkgs.playerctl;
  #socat = lib.getExe pkgs.socat;
  jq = lib.getExe pkgs.jq;
in
{
  home.packages = with pkgs; [
    networkmanagerapplet
    wttrbar
  ];

  programs.waybar = {
    enable = true;
    style = ./style.css;

    settings = {
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
          #"custom/power"
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

          # TODO: add an on-click to change language
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

        # Shoutouts to wyatt
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
          exec = pkgs.writeShellScript "queryMedia" ''
            	#!/bin/sh
            	player_priority="cider, spotify, vlc, firefox, chromium"
            	metadata_format="{\"playerName\": \"{{ playerName }}\", \"status\": \"{{ status }}\", \"title\": \"{{ title }}\", \"artist\": \"{{ artist }}\"}"

            	${playerctl} --follow -a --player "$player_priority" metadata --format "$metadata_format" |
                  while read -r _; do
                    active_stream=$(${playerctl} -a --player "$player_priority" metadata --format "$metadata_format" | ${jq} -s 'first([.[] | select(.status == "Playing")][] // empty)')
                    echo ""
                    echo "$active_stream" | ${jq} --unbuffered --compact-output --arg maxlen 50 '
                      def truncate($len):
                        (if length > ($len | tonumber) 
                         then (.[0:($len | tonumber - 3)] + "...") 
                         else . end) | gsub("&"; "&amp;");
                      
                      .class = .playerName
                      | .alt = .playerName
                      | .text = "\(.title) - \(.artist)"
                      | .text |= truncate($maxlen | tonumber)'
                  done	
          '';

          on-click = ''
            bash -c '
              player_priority="cider, spotify, vlc, firefox, chromium"
              # Find the first player in priority order that is running
              active=$(playerctl -l \
                        | tr "," "\n" \
                        | grep -E "^(cider|spotify|vlc|firefox|chromium)$" \
                        | head -n1)
              if [ -n "$active" ]; then
                # Launch or focus the app; adjust commands if your binaries differ
                case "$active" in
                  cider)     cider         ;;  # assume `cider` is the launch command
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
    };
  };

  home.file = {
    ".config/waybar/power_menu.xml" = {
      text = ''
        		<?xml version="1.0" encoding="UTF-8"?>
        		<interface>
        		  <object class="GtkMenu" id="menu">
        			<child>
        			  <object class="GtkMenuItem" id="suspend">
        				<property name="label">Suspend</property>
        			  </object>
        			</child>
        			<child>
        			  <object class="GtkMenuItem" id="hibernat">
        				<property name="label">Hibernate</property>
        			  </object>
        			</child>
        			<child>
        			  <object class="GtkMenuItem" id="shutdown">
        				<property name="label">Shutdown</property>
        			  </object>
        			</child>
        			<child>
        			  <object class="GtkSeparatorMenuItem" id="delimiter1"/>
        			</child>
        			<child>
        			  <object class="GtkMenuItem" id="reboot">
        				<property name="label">Reboot</property>
        			  </object>
        			</child>
        		  </object>
        		</interface>
        	  '';
    };

    ".config/waybar/colours.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/stylix/colours.css";
  };
}
