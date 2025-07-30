{ lib, ... }:

{
  imports = [
    ./binds.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./main.nix
  ];

  options.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland Wayland compositor";

    mainMonitor = lib.mkOption {
      type = lib.types.str;
      default = "eDP-1";
      description = "Primary monitor identifier.";
    };

    mainMod = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
    };

    monitorResolution = lib.mkOption {
      type = lib.types.str;
      default = "2560x1600@165";
      description = "Resolution and refresh rate for the main monitor.";
    };

    monitorScale = lib.mkOption {
      type = lib.types.str;
      default = "1.6";
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal emulator.";
    };

    fileManager = lib.mkOption {
      type = lib.types.str;
      default = "thunar";
      description = "Default file manager.";
    };

    menu = lib.mkOption {
      type = lib.types.str;
      default = "wofi";
      description = "Launcher/menu program.";
    };

    env = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "NIXOS_OZONE_WL, 1"
        "OZONE_PLATFORM, wayland"
        "ELECTRON_OZONE_PLATFORM_HINT, wayland"

        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SCREENSHOTS_DIR, $HOME/Media/screenshots"
        "XDG_PICTURES_DIR, $HOME/Media/screenshots/"
        "XDG_VIDEOS_DIR, $HOME/Media/Videos/"

        "SCREENSHOT_APP, grimblast --notify --freeze copysave"

        "QT_QPA_PLATFORM, wayland"
        "GDK_SCALE, 1.6"

        #"XCURSOR_SIZE, 16"

        # NVIDIA GBM backend (critical for Wayland)
        "GBM_BACKEND, nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME, nvidia"

        # TODO: Will eventually have to make this a bit more dynamic so it works on more than just
        # my laptop.
        # Run iGPU mainly, dGPU secondarily

        "AQ_DRM_DEVICES, /dev/dri/card1:/dev/dri/card0"
        "LIBVA_DRIVER_NAME,nvidia"
        # GSync/VRR Control (set per-game if needed)
        "__GL_GSYNC_ALLOWED, 1"
        # Disable Adaptive Sync globally to avoid flickering
        "__GL_VRR_ALLOWED, 0"
      ];
      description = "Extra environment variables for Hyprland sessions.";
    };
  };
}
