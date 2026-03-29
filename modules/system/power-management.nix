{
  # TODO: review
  my.power-management.nixos.services = {
    auto-cpufreq.enable = false;
    upower.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        TLP_DEFAULT_MODE = "BAT";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # Cap CPU Performance on Battery Power to 20%
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        #WIFI_PWR_ON_AC  = "on";
        #WIFI_PWR_ON_BAT = "on";

        AUTO_PLATFORM_PROFILE = 0;
        PLATFORM_PROFILE_ON_AC = "low-power";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # Radio Device
        RESTORE_DEVICE_STATE_ON_STARTUP = 1;
        #DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi wwan";

        # If want to be more aggressive, use force option
        #DEVICES_TO_DISABLE_ON_BAT = "bluetooth";
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";

        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi wwan";
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";

        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_AUDIO = 1;
        USB_EXCLUDE_BTUSB = 0;
        USB_EXCLUDE_PHONE = 0;

        #START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 1;

        #RADEON_DPM_PERF_LEVEL_ON_AC  = "auto";
        #RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";
      };
    };
  };
}
