{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.hyprland;
  hyprSettings = import ./settings.nix { inherit cfg; };
  hyprScripts = import ./scripts.nix { inherit pkgs; };
in
{
  config = lib.mkIf cfg.enable {
    hyprlandUnityFix = {
      enable = true;
      configRules = [

      ];
    };

    home.packages = hyprScripts.packages;

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = true;
      settings = hyprSettings;
    };
  };
}
