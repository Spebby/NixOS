{ config, lib, ... }:

let
  cfg = config.hyprland;
in
{
  services.hypridle = lib.mkIf cfg.enable {
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
        #{
        #  timeout = 1200;
        #  on-timeout = "systemctl suspend";
        #}
      ];
    };
  };
}
