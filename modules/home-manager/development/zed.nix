# /home-manager/modules/zed.nix

{ config, lib, ... }:

let
  cfg = config.zed;
in
{
  options.zed = {
    enable = lib.mkEnableOption "Enable Zed Editor";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        ai = false;
        vim_mode = true;
      };

      description = "Zed Editor config settings.";
    };
  };

  config = {
    programs.zed-editor = {
      inherit (cfg) enable;
      extensions = [
        "html"
        "make"
        "nix"
        "toml"
        "rust"
        "zig"
      ];
      userSettings = {
        assistant = {
          enabled = cfg.settings.ai;
        };

        terminal = {
          env = {
            TERM = config.terminals.default or "kitty";
          };
          shell = "system";
        };

        hour_format = "hour24";
        inherit (cfg.settings) vim_mode;
        show_whitespace = "all";
      };
    };
  };
}
