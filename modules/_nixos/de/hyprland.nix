{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.hyprland;
in
{
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland wayland compositor";
    withUWSM = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };

    programs.hyprland = { inherit (cfg) enable withUWSM; };

    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    };

    security = {
      pam.services.hyprlock = { };
      rtkit.enable = true;
    };
    # Hyprland auto-installs and configures its XDG portal
  };
}
