# /home-manager/modules/godot.nix

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.godot;
in
{
  options.godot.enable = lib.mkEnableOption "Enable the Godot game engine";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      godot-mono
      dotnetCorePackages.dotnet_8.sdk
      godot-export-templates-bin
    ];

    xdg.desktopEntries.godot-mono = {
      name = "Godot Engine (Mono)";
      exec = "${pkgs.godot-mono}/bin/godot-mono --single-window %F";
      icon = "godot";
      terminal = false;
      categories = [
        "Development"
        "X-GameEngine"
      ];
    };
  };
}
