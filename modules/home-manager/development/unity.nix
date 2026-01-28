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
        sha256 = "PK6fq9ZtKmmiLVVamKIjCzI721avIgxfxl5bWrAXEmw=";
      };

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ super.dpkg ];
    });

    plasticscm-client-gui-unwrapped = super.plasticscm-client-gui-unwrapped.overrideAttrs (old: rec {
      src = super.fetchurl {
        inherit (old.src) url;
        sha256 = "9K1ttKQFSW5iMVnBvDGEnSgm3gnUaErfktjgNDooZOo=";
      };

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ super.dpkg ];
    });

    plasticscm-client-core-unwrapped = super.plasticscm-client-core-unwrapped.overrideAttrs (old: {
      src = super.fetchurl {
        inherit (old.src) url;
        sha256 = "yOVcZUXeNfcd21jXUUpuaLs8P6z7s3dbQMKmQy/3m2Y=";
      };

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ super.dpkg ];
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
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ plasticOverlay ];

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
