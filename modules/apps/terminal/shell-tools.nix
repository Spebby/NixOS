{
  my.apps._.shell.provides.tools.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.shell.tools;
    in
    {
      options.my.apps._.shell.tools = {
        bat = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable bat (modern cat replacement)";
          };
          themes = lib.mkOption {
            type = lib.types.attrsOf lib.types.attrs;
            default = {
              dracula = {
                src = pkgs.fetchFromGitHub {
                  owner = "Briles";
                  repo = "gruvbox";
                  rev = "75407cc80c51814d61beb1df07e380d6f58ad767";
                  sha256 = "186rhbljw80psf1l8hyj02ycz1wzxv4rxmbrqr8yvi30165drpay";
                };
                file = "gruvbox (Dark) (Medium).sublime-color-scheme";
              };
            };
            description = "Themes for bat syntax highlighting.";
          };
        };

        eza = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable eza (modern ls replacement)";
          };
          enableZshIntegration = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable ZSH integration.";
          };
          git = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable git integration.";
          };
          colors = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.either lib.types.bool (
                lib.types.enum [
                  "auto"
                  "always"
                  "never"
                ]
              )
            );
            default = "always";
            description = "Color mode for eza.";
          };
          icons = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.either lib.types.bool (
                lib.types.enum [
                  "auto"
                  "always"
                  "never"
                ]
              )
            );
            default = "always";
            description = "Icon mode for eza.";
          };
          extraOptions = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "--group-directories-first"
              "--header"
            ];
            description = "Extra CLI options for eza.";
          };
        };
      };

      config = {
        programs.bat = lib.mkIf cfg.bat.enable { inherit (cfg.bat) enable themes; };
        programs.eza = lib.mkIf cfg.eza.enable {
          inherit (cfg.eza)
            enable
            enableZshIntegration
            git
            colors
            icons
            extraOptions
            ;
        };
      };
    };
}
