{
  my.apps._.protonup.homeManager =
    { config, lib, pkgs, ... }:
    let
      cfg = config.my.apps._.protonup;
    in
    {
      options.my.apps._.protonup = {
        enable = lib.mkEnableOption "ProtonUp-Qt/CLI helper";
        toolsPath = lib.mkOption {
          type = lib.types.str;
          default = "$HOME/.steam/root/compatibilitytools.d";
          description = "Path exported as STEAM_EXTRA_COMPAT_TOOLS_PATHS.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.protonup-ng ];
        home.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = cfg.toolsPath;
      };
    };
}
