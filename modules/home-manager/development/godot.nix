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
      godot-export-templates-bin
      dotnetCorePackages.dotnet_8.sdk
    ];
  };
}
