{ pkgs, lib, ... }:

let
  swayncClient = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
  playerctl = lib.getExe pkgs.playerctl;
  socat = lib.getExe pkgs.socat;
  jq = lib.getExe pkgs.jq;

  player_priority = "cider, spotify, vlc, firefox, chromium";
in
{
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
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "hyprland/submap"
          "custom/weather"
          "pulseaudio"
          "battery"
          "custom/power"
          "clock"
          "custom/notification"
          "tray"
        ];
        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = false;
          special-visible-only = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            #"1" = "";
            #"2" = "";
            #"3" = "";
            #"4" = "";
            #"5" = "";
            #"6" = "";
            #"7" = "";
            #"8" = "";
            "unity" = "";
            "magic" = "";
            "game" = "";
          };

          #          persistent-workspaces = {
          #            "*" = 9;
          #          };
        };

        "hyprland/submap" = {
          format = " {}";
          max-length = 8;
          tooltip = false;
          always-on = false;
        };

        "hyprland/language" = {
          format-en = "🇺🇸";
          format-ru = "🇷🇺";
          format-he = "🇮🇱";
          min-length = 5;
          tooltip = false;

          # TODO: add an on-click to change language
        };

        "custom/weather" = {
          format = " {} ";
          exec = "curl -s 'wttr.in/?format=%c%t'";
          interval = 300;
          class = "weather";
          tooltip = "curl -s 'wttr.in/?format=%l";
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
            shutdown = "shutdown";
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
          format = "{:%d/%m/%y %H:%M}";
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
            firefox = "󰈹";
            vlc = "";
            default = "";
          };

          return-type = "json";
          exec-if = "which ${playerctl}";
          exec = pkgs.writeShellScript "queryMedia" ''
            #!/bin/sh
            metadata_format="{\"playerName\": \"{{ playerName }}\", \"status\": \"{{ status }}\", \"title\": \"{{ title }}\", \"artist\": \"{{ artist }}\"}"

            ${playerctl} --follow -a --player "$player_priority" metadata --format "$metadata_format" |
              while read -r _; do
            	active_stream=$(${playerctl} -a --player "$player_priority" metadata --format "$metadata_format" | ${jq} -s 'first([.[] | select(.status == "Playing")][] // empty)')
            	echo ""
            	echo "$active_stream" | ${jq} --unbuffered --compact-output \
            	  '.class = .playerName | .alt = .playerName | .text = "\(.title) - \(.artist)"'
              done
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
  };
}
