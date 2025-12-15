# /hosts/common.nix

{
  lib,
  inputs,
  pkgs,
  ...
}:

{
  # This is gross but unless I want to hardcode pkgs in /lib/makeSystem.nix, I have to do this.
  # This is also why pkgs-stable is not configurable here.
  nixpkgs.config.allowUnfree = true;
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.backupFileExtension = "backup";
  nix.settings = {
    trusted-users = [
      "root"
      "thom"
      "max"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Tell Nix WHERE to look
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
      "https://cuda-maintainers.cachix.org/"
      "https://cosmic.cachix.org/"
    ];

    # Tell Nix which of those locations it's ALLOWED to trust
    trusted-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
      "https://cuda-maintainers.cachix.org/"
      "https://cosmic.cachix.org/"
    ];

    # The public keys for the trusted substituters
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };

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

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

    # Don't set configPackages - let each DE use its own
    # Or set it to an empty list to prevent auto-configuration
    configPackages = lib.mkForce [ ];

    # Configure portal backend each DE should use
    config = {
      # Default fallback for unknown DEs
      common = {
        default = [ "gtk" ];
      };

      # COSMIC Desktop
      cosmic = {
        default = [
          "cosmic"
          "gtk"
        ];
        # specify per-interface if needed:
        # "org.freedesktop.impl.portal.Screenshot" = [ "cosmic" ];
        # "org.freedesktop.impl.portal.FileChooser" = [ "cosmic" ];
      };

      # GNOME
      gnome = {
        default = [
          "gnome"
          "gtk"
        ];
      };

      # Hyprland
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };

  # Global Packages
  environment = {
    systemPackages = with pkgs; [
      ntfs3g
      git
      home-manager
      openssl
      wget
      keychain

      # Audio Tooling
      alsa-tools
      pavucontrol
      ffmpeg-full

      # Programming Stuff
      ## CXX
      clang
      gcc
      meson
      cmake
      gnumake
      cpio
      binutils
      gdb

      # Other
      python311
      live-server
      zig
      odin

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
      mesa-demos
      lshw-gui
      usbutils
      # Consider Toybox?

      nix-prefetch-git
      wayland-utils
      edid-decode

      # SDDM Themes
      sddm-astronaut
      sddm-chili-theme

      # Nix Utils
      nurl
      nix-your-shell
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
