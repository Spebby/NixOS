# /hosts/common.nix

{ inputs, pkgs, ... }:

{
  # This is gross but unless I want to hardcode pkgs in /lib/makeSystem.nix, I have to do this.
  # This is also why pkgs-stable is not configurable here.
  nixpkgs.config.allowUnfree = true;
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.backupFileExtension = "backup";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;

  # Boot options
  boot = {
    loader = {
      systemd-boot.enable = false;
      # the "/boot" thing can probably be made more "modular" but igaf rn
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;

        memtest86 = {
          enable = false;
          # Make Memtest86+, a memory testing program, available from the GRUB boot menu.
          params = [ "onepass" ];
        };
      };
    };
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
  };
  programs.zsh.enable = true;

  # Global Packages
  environment = {
    systemPackages = with pkgs; [
      ntfs3g
      git
      home-manager
      openssl
      wget
      gnome-keyring

      # Audio Tooling
      alsa-tools
      pavucontrol

      # Programming Stuff
      ## CXX
      clang
      gcc
      meson
      cmake
      gnumake
      cpio
      binutils

      ## Other
      python311Full
      zig

      # Basic editors
      vim
      nano

      # Utils
      acpid
      cowsay
      gparted
      ncdu
      lsof
      pciutils
      udisks
      glxinfo
      lshw-gui
      usbutils
      # Consider Toybox?

      nix-prefetch-git
    ];

    variables = {
      CC = "clang";
      CXX = "clang++";
    };

    sessionVariables = rec {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      XDG_BIN_HOME = "$HOME/.local/bin";
      ROFI_SCREENSHOT_DIR = "$HOME/Media/screenshots/";
      PATH = [ "${XDG_BIN_HOME}" ];
      MOZ_USE_XINPUT2 = "1";
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    flatpak.enable = true;
    gvfs.enable = true; # Mount, Trash, etc
    tumbler.enable = true; # Thumbnail support for images

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true; # review if i actually need this one

      # This is not valid nix: Essentially, my PC always has the camera active,
      # even when it really should be disabled. With some TLP wizardry I could
      # probably figure it out... for now, don't worry about it.
      # This is apparently a pipewire/wireplumber specific bug. Need to research more.
      #    wireplumber.profiles = {
      #      main = {
      #        monitor.libcamera.enable = false;
      #      };
      #    };
    };

    blueman.enable = true;
  };

  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          keepEnv = true;
          groups = [ "wheel" ];
          noPass = true;
        }
      ];
    };
  };

  # Timezones
  time.timeZone = "America/Los_Angeles";
  #services.automatic-timezoned.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ZRAM
  zramSwap = {
    enable = false;
    algorithm = "lz4";
    memoryPercent = 100;
    priority = 999;
  };
}
