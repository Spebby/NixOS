# /home-manager/modules/yazi.nix

{
  config,
  pkgs,
  lib,
  ...
}:

# todo: https://github.com/yazi-rs/plugins/tree/main/git.yazi
let
  cfg = config.yazi;
in
{
  options.yazi = {
    enable = lib.mkEnableOption "Enable Yazi file viewer";
    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ yaziPlugins.git ];
    programs.yazi = { inherit (cfg) enable enableZshIntegration; };
  };
}
