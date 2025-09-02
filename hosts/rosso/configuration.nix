# /hosts/rosso/configuration.nix

{
  pkgs,
  stateVersion,
  hostname,
  ...
}:

{
  networking.hostName = hostname;
  system.stateVersion = stateVersion;

  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ./drivers.nix
    ../common.nix # Common to hosts
    ../../modules/nixos
    ../../users/thom.nix
    ../../users/max.nix
  ];

  # TODO: move the theme specific stuff to machine specific configs.
  # I also like owl, Loader 2, Spinner Alt, Splash, Cuts Alt, DNA, Hexagon Dots Alt, Hexagons
  boot = {
    loader.grub = {
      theme = "${import ./grubtheme.nix { inherit pkgs; }}";
      configurationLimit = 5;
    };
    plymouth = {
      enable = true;
      theme = "cuts_alt";
      #extraConfig = "DeviceScale=1\n"; # Force Frame Buffer refresh b4 suspend
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override { selected_themes = [ "cuts_alt" ]; })
      ];
      extraConfig = "DeviceScale=1.5";
    };

    # Silent Boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "resume=/.swapfile"
    ];
    kernelPackages = pkgs.linuxPackages_zen;
    # Hide OS choice for bootloader
    # loader.timeout = 0;
  };

  nix = {
    optimise = {
      automatic = true;
    };
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      home-manager
      bottles
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ jetbrains-mono ];
  };

  cosmic = {
    enable = true;
    useCosmicGreeter = false;
  };
  gnome = {
    enable = true;
    usePowerProfile = false;
  };
  hyprland.enable = true;
  kde = {
    enable = false;
    useSDDM = true;
  };

  ollama.enable = false;

  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    backupFileExtension = "hm-backup";
    sharedModules = [ { home.stateVersion = stateVersion; } ];
  };

  services = {
    auto-cpufreq.enable = false;
    tlp = {
      enable = true;
      settings = {
        TLP_DEFAULT_MODE = "BAT";

        CPU_BOOST_ON_AC = 0;
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

        PLATFORM_PROFILE_ON_AC = "performance";
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
        STOP_CHARGE_THRESH_BAT0 = 80;

        #RADEON_DPM_PERF_LEVEL_ON_AC  = "auto";
        #RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";
      };
    };

    displayManager = {
      defaultSession = "gnome";
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${import ./sddm.nix { inherit pkgs; }}";
      };
    };
  };
}
