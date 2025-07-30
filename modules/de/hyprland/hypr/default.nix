{ lib, ... }:

{
  imports = [
    ./binds.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./main.nix
  ];

  options.hyprlandSettings = {
    mainMonitor = lib.mkOption {
      type = lib.types.str;
      default = "eDP-1";
      description = "Primary monitor identifier.";
    };

    monitorResolution = lib.mkOption {
      type = lib.types.str;
      default = "2560x1600@165";
      description = "Resolution and refresh rate for the main monitor.";
    };

    envVars = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "NIXOS_OZONE_WL,1"
        "OZONE_PLATFORM,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SCREENSHOTS_DIR,$HOME/Media/screenshots"
        "XDG_PICTURES_DIR,$HOME/Media/screenshots/"
        "XDG_VIDEOS_DIR,$HOME/Media/Videos/"
        "SCREENSHOT_APP,grimblast --notify --freeze copysave"
        "QT_QPA_PLATFORM,wayland"
        "GDK_SCALE,1.6"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GL_GSYNC_ALLOWED,1"
        "__GL_VRR_ALLOWED,0"
      ];
      description = "Extra environment variables for Hyprland sessions.";
    };
  };
}
