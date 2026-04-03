{
  my.apps._.dev._.tooling.homeManager =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.dev._.tooling;
    in
    {
      options.my.apps._.dev._.tooling = {
        enable = lib.mkEnableOption "developer tooling application bundle";

        includeGithub = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install GitHub CLI.";
        };

        includeNode = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install Node.js.";
        };

        includeEditor = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install Visual Studio Code.";
        };

        includeBuildDocs = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install meson and doxygen_gui.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the dev tooling set.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages =
          (lib.optionals cfg.includeGithub [ pkgs.gh ])
          ++ (lib.optionals cfg.includeNode [ pkgs.nodejs ])
          ++ (lib.optionals cfg.includeEditor [ pkgs.vscode ])
          ++ (lib.optionals cfg.includeBuildDocs [
            pkgs.meson
            pkgs.doxygen_gui
          ])
          ++ cfg.extraPackages;
      };
    };
}
