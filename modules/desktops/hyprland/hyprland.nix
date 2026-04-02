{ my, ... }:
{
  my.desktops._.hyprland = {
    includes = [ my.desktops._.base ];

    nixos =
      { lib, config, ... }:
      let
        cfg = config.my.desktops._.hyprland;
      in
      {
        options.my.desktops._.hyprland = {
          withUWSM = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable UWSM integration for Hyprland sessions.";
          };
        };

        config = {
          programs.hyprland = {
            enable = true;
            inherit (cfg) withUWSM;
          };

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
        };
      };

    homeManager =
      { lib, config, ... }:
      let
        cfg = config.my.desktops._.hyprland.home;
      in
      {
        options.my.desktops._.hyprland.home.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Home Manager Hyprland desktop configuration bundle.";
        };

        imports = [ ./_home.nix ];

        config.hyprland.enable = cfg.enable;
      };
  };
}
