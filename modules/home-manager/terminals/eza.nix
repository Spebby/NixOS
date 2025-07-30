# /home-manager/modules/eza.nix

{ config, lib, ... }:

let
  cfg = config.terminals.eza;
in
{
  options.terminals.eza = {
    enable = lib.mkEnableOption "Enable eza (modern ls replacement)";
    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ZSH integration";
    };

    git = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git integration";
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
      description = ''
        Whether to use colors in eza.

        Accepts:
          - null (default from upstream)
          - "auto"
          - "always"
          - "never"
      '';
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
      description = ''
        Whether to display icons in eza.

        Accepts:
          - null (default from upstream)
          - "auto"
          - "always"
          - "never"
      '';
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "--group-directories-first"
        "--header"
      ];
      description = "Additional command-line options to pass to eza.";
    };

  };

  config.programs.eza = {
    inherit (cfg)
      enable
      enableZshIntegration
      git
      colors
      icons
      extraOptions
      ;
  };
}
