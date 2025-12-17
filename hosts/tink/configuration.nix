# /hosts/rosso/configuration.nix

{
  inputs,
  pkgs,
  stateVersion,
  hostname,
  ...
}:

let
  grass-bg = pkgs.runCommand "grass-bg.mp4" { } ''
    cp ${../../backgrounds/wavy-grass-moewalls-com.mp4} $out
  '';
  grass-placeholder = pkgs.runCommand "grass-placeholder.png" { } ''
    cp ${../../backgrounds/wavy-grass-placeholder.png} $out
  '';
  sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    theme = "rei";
    extraBackgrounds = [
      grass-bg
      grass-placeholder
    ];
    # https://github.com/uiriansan/SilentSDDM/wiki/Options/
    theme-overrides = {
      "General" = {
        scale = "1.0";
        enable-animations = true;
        background-fill-mode = "fill";
        animated-background-placeholder = "${grass-placeholder.name}";
      };
      "LoginScreen" = {
        background = "${grass-bg.name}";
        animated-background-placeholder = "${grass-placeholder.name}";
      };
      "LockScreen" = {
        background = "${grass-bg.name}";
        animated-background-placeholder = "${grass-placeholder.name}";
      };
      "LoginScreen.MenuArea.Session" = {
        position = "bottom-left";
      };
    };
  };
in
{
  networking = {
    hostName = hostname;
    firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --source 192.168.0.0/24 --dport 1714:65535 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --source 192.168.0.0/24 --dport 1714:65535 -j nixos-fw-accept
    '';
  };
  system.stateVersion = stateVersion;

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
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        theme = "${import ../rosso/grubtheme.nix { inherit pkgs; }}";
        configurationLimit = 5;
      };
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
      sddm-theme
      sddm-theme.test
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
  hyprland.enable = false;
  kde = {
    enable = false;
    useSDDM = false;
  };

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
        package = pkgs.kdePackages.sddm; # qt6 version
        enable = true;
        wayland.enable = true;
        theme = sddm-theme.pname;
        extraPackages = sddm-theme.propagatedBuildInputs;
        settings = {
          # required for styling the virtual keyboard
          General = {
            GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };
    };
  };
}
