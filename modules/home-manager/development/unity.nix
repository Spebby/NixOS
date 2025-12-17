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

  # downstream overlay for hash mismatch fix. will be irrelevant at some point.
  plasticOverlay = self: super: {
    plasticscm-theme = super.plasticscm-theme.overrideAttrs (old: rec {
      src = super.fetchurl {
        inherit (old.src) url;
        sha256 = "gs9XGqpgxWue+Cke8x5FeyUDfQK8R/IrwWP59NRmubI=";
      };
    });

    plasticscm-client-gui-unwrapped = super.plasticscm-client-gui-unwrapped.overrideAttrs (old: rec {
      src = super.fetchurl {
        inherit (old.src) url;
        sha256 = "cilxGuy5Y6t/UImje0625qrfwgNp1gp7qKA1fpPcw2g=";
      };
    });

    plasticscm-client-core-unwrapped = super.plasticscm-client-core-unwrapped.overrideAttrs (old: {
      src = super.fetchurl {
        inherit (old.src) url;
        sha256 = "/tfZLJ3a/6Jdk3opRKs+3/l09bFViN7/YuQ0hxVy4J8=";
      };
    });
  };
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
    useVerco = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Verco Plastic SCM client";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ plasticOverlay ];

    assertions = [
      {
        assertion = !cfg.useVerco || cfg.usePlastic;
        message = "unity.useVerco requires unity.usePlastic to be enabled.";
      }
    ];

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
      ++ lib.optionals cfg.usePlastic ([ plasticscm-client-complete ] ++ lib.optional cfg.useVerco verco);

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
