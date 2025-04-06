{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 60;
          on-timeout = "brightnessctl -s set 30 && brightnessctl -sd set rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -r && brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = 90;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 120;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
