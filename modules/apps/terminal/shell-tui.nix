{
  my.apps._.shell.tui.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.shell.tui;
    in
    {
      options.my.apps._.shell.tui = {
        yazi = {
          enable = lib.mkEnableOption "Yazi file manager";
          enableZshIntegration = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Zsh integration for Yazi.";
          };
        };

        zathura = {
          enable = lib.mkEnableOption "Zathura document reader";
          mappings = lib.mkOption {
            type = lib.types.attrs;
            default = {
              D = "toggle_page_mode";
              d = "scroll half_down";
              u = "scroll half_up";
            };
            description = "Zathura key mappings.";
          };
          options = {
            font = lib.mkOption {
              type = lib.types.str;
              default = "JetBrains Mono Bold 13";
              description = "Zathura font string.";
            };
          };
        };
      };

      config = {
        home.packages = lib.mkIf cfg.yazi.enable (with pkgs; [ yaziPlugins.git ]);

        programs.yazi = lib.mkIf cfg.yazi.enable { inherit (cfg.yazi) enable enableZshIntegration; };
        programs.zathura = lib.mkIf cfg.zathura.enable { inherit (cfg.zathura) enable mappings options; };
      };
    };
}
