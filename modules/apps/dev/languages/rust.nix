{ lib, config, ... }:
{
  my.apps._.dev.provides.rust = {
    nixos =
      { pkgs, ... }:
      let
        cfg = config.my.apps._.dev.rust;
      in
      {
        options.my.apps._.dev.rust = {
          includeToolchain = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install the core Rust toolchain (rustc, cargo, rustfmt, clippy).";
          };

          includeAnalyzer = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install rust-analyzer language server.";
          };

          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Additional Rust development packages.";
          };
        };

        config.environment.systemPackages =
          (lib.optionals cfg.includeToolchain [
            pkgs.rustc
            pkgs.cargo
            pkgs.rustfmt
            pkgs.clippy
          ])
          ++ (lib.optionals cfg.includeAnalyzer [ pkgs.rust-analyzer ])
          ++ cfg.extraPackages;
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.bacon
          pkgs.cargo-watch
        ];
      };
  };
}
