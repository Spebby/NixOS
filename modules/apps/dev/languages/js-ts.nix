{ lib, ... }:
{
  my.apps._.dev.provides.js-ts.homeManager =
    { config, pkgs, ... }:
    let
      cfg = config.my.apps._.dev.jsTs;
    in
    {
      options.my.apps._.dev.jsTs = {
        includePackageManagers = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install yarn and pnpm package managers.";
        };

        includeQualityTools = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install eslint and prettier.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional JS/TS tooling packages to install.";
        };
      };

      config = {
        home.packages = [
          pkgs.nodejs
          pkgs.typescript
          pkgs.typescript-language-server
        ]
        ++ (lib.optionals cfg.includePackageManagers [
          pkgs.yarn
          pkgs.pnpm
        ])
        ++ (lib.optionals cfg.includeQualityTools [
          pkgs.eslint
          pkgs.prettier
        ])
        ++ cfg.extraPackages;
      };
    };
}
