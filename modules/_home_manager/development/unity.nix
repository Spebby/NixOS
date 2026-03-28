# /home-manager/modules/unity.nix

{
  config,
  pkgs,
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
    usePlastic = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Plastic SCM GUI client";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages =
      with pkgs;
      [
        (pkgs.unityhub.override {
          extraLibs =
            pkgs: with pkgs; [
              harfbuzz
              libogg
            ];
        })
      ]
      ++ lib.optionals cfg.usePlastic [ plasticscm-client-complete ];

    xdg.desktopEntries.unityhub = {
      name = "Unity Hub";
      # Note: env GDK_SCALE=2 GDK_DPI_SCALE=0.5 works well for higher res displays. Does not work great for my laptop!
      exec = "${pkgs.unityhub}/bin/unityhub --ozone-platform-hint=auto --  %U";
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
