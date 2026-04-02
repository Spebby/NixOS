{ my, ... }:
{
  my.desktops._.kde = {
    includes = [ my.desktops._.base ];

    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.my.desktops._.kde;
      in
      {
        options.my.desktops._.kde = {
          useSDDM = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable SDDM as the display manager for Plasma.";
          };

          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = with pkgs; [
              kdePackages.discover
              kdePackages.kcalc
              kdePackages.kcharselect
              kdePackages.kcolorchooser
              kdePackages.kolourpaint
              kdePackages.ksystemlog
              kdePackages.sddm-kcm
              kdiff3
              kdePackages.isoimagewriter
              kdePackages.partitionmanager
              hardinfo2
              haruna
              wayland-utils
              wl-clipboard
            ];
            description = "Extra utility packages installed with KDE Plasma.";
          };
        };

        config = {
          environment.systemPackages = cfg.extraPackages;

          services = {
            desktopManager.plasma6.enable = true;
            displayManager.sddm = lib.mkIf cfg.useSDDM {
              enable = true;
              wayland.enable = true;
            };

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

          security.rtkit.enable = true;
        };
      };
  };
}
