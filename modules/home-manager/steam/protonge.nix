{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.protonUp;
in
{
  options.protonUp.enable = lib.mkEnableOption "Enable ProtonUp";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ protonup ];

    # Make sure to run "protonup" every now and then.
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
