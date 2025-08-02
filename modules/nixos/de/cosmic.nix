{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.cosmic;
in
{
  options.cosmic = {
    enable = lib.mkEnableOption "Enable COSMIC Desktop Environment";
    useCosmicGreeter = lib.mkEnableOption "Enable the COSMIC Greeter";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    environment = {
      systemPackages = with pkgs; [ firefox ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        COSMIC_DATA_CONTROL_ENABLED = 1;
      };
    };

    services = {
      desktopManager.cosmic = {
        enable = true;
      };

      displayManager.cosmic-greeter.enable = cfg.useCosmicGreeter;

      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      power-profiles-daemon.enable = false;
    };

    security.rtkit.enable = true;
  };
}
