# /home-manager/modules/zathura.nix

{ config, lib, ... }:

let
  cfg = config.zathura;
in
{
  options.zathura = {
    enable = lib.mkEnableOption "Enable Zathura document reader";
    mappings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        D = "toggle_page_mode";
        d = "scroll half_down";
        u = "scroll half_up";
      };
    };

    options = {
      font = lib.mkOption {
        type = lib.types.str;
        default = "JetBrains Mono Bold 13";
      };
    };
  };

  config.programs.zathura = { inherit (cfg) enable mappings options; };
}
