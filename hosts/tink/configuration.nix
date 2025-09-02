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

  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../common.nix # Common to hosts
    ../../modules/nixos
    ../../users/max.nix
  ];

  # TODO: move the theme specific stuff to machine specific configs.
  # I also like owl, Loader 2, Spinner Alt, Splash, Cuts Alt, DNA, Hexagon Dots Alt, Hexagons
  boot = {
    loader.grub = {
      theme = "${import ../rosso/grubtheme.nix { inherit pkgs; }}";
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
      extraConfig = "DeviceScale=1";
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
    enable = false;
    useCosmicGreeter = false;
  };
  gnome = {
    enable = true;
    usePowerProfile = false;
  };
  hyprland.enable = false;
  kde = {
    enable = false;
    useSDDM = false;
  };

  ollama.enable = false;

  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    backupFileExtension = "hm-backup";
    sharedModules = [ { home.stateVersion = stateVersion; } ];
  };

  services = {
    auto-cpufreq.enable = false;
    tlp.enable = false;

    displayManager = {
      defaultSession = "gnome";
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${import ../rosso/sddm.nix { inherit pkgs; }}";
      };
    };
  };
}
