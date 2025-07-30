# /modules/discord

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.discord;
  useCustom = cfg.customClient.enable;
in
{
  options.discord = {
    enable = lib.mkEnableOption "Enable Discord";
    customClient.enable = lib.mkEnableOption "Enable third-party client for Discord (e.g. Vesktop)";
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
      ++ lib.optional useCustom vesktop;
  };
}
