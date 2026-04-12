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
        includeGithub = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install GitHub CLI.";
        };

        includeBuildDocs = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install meson and doxygen_gui.";
        };

        includeAiTools = {
          enable = lib.mkEnableOption "Install CLI AI coding assistant (OpenCode & optional ClaudeCode)";
          claude = {
            enable = lib.mkEnableOption "Install ClaudeCode CLI tool.";
          };
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the dev tooling set.";
        };
      };

      config = {
        home.packages = [
          pkgs.cpio
          pkgs.binutils
          pkgs.gdb
        ]
        ++ (lib.optionals cfg.includeGithub [ pkgs.gh ])
        ++ (lib.optionals cfg.includeBuildDocs [
          pkgs.meson
          pkgs.doxygen_gui
        ])
        ++ (lib.optionals cfg.includeAiTools.enable [ pkgs.opencode ])
        ++ (lib.optionals (cfg.includeAiTools.enable && cfg.includeAiTools.claude.enable) [
          pkgs.claude-code
        ])
        ++ cfg.extraPackages;
      };
    };
}
