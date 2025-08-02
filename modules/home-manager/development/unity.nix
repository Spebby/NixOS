# /home-manager/modules/unity.nix

{
  config,
  pkgs-stable,
  lib,
  ...
}:

# TODO: investigate if i can get rid of the openssl mask
# Unity is superrrr cool and uses an old version of openssl for no good reason
let
  cfg = config.unity;
in
{
  # For UNITY. Again, investigate if I can remove this garbage.
  options.unity = {
    enable = lib.mkEnableOption "Enable Unity game engine";
    useVerco = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Verco Plastic SCM client";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages =
      with pkgs-stable;
      [
        (pkgs.unityhub.override {
          extraLibs =
            pkgs-stable: with pkgs-stable; [
              harfbuzz
              libogg
            ];
        })
      ]
      ++ lib.optional cfg.useVerco verco;

    xdg.desktopEntries.unityhub = {
      name = "Unity Hub";
      # Note: env GDK_SCALE=2 GDK_DPI_SCALE=0.5 works well for higher res displays. Does not work great for my laptop!
      exec = "${pkgs-stable.unityhub}/bin/unityhub --ozone-platform-hint=auto --  %U";
      icon = "unityhub";
      comment = "The Official Unity Hub";
      type = "Application";
      categories = [ "Development" ];
      settings = {
        StartupWMClass = "UnityHub";
        Terminal = "false";
        TryExec = "unityhub";
        MimeType = "x-scheme-handler/unityhub";
      };
    };
  };
}
