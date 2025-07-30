# /modules/discord

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.discord;
in
{
  options.discord = {
    enable = lib.mkEnableOption "Enable Discord";
    useCustomClient = lib.mkEnableOption "Enable third-party client for Discord (e.g. Vesktop)";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        (discord-canary.override {
          withOpenASAR = true;
          withVencord = true;
        })
      ]
      ++ lib.optional cfg.useCustomClient vesktop;
  };
}
