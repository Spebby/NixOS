{
  my.apps._.engines._.unity.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.apps._.unity;
    in
    {
      options.my.apps._.unity = {
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
    };
}
