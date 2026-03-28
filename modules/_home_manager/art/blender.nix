# /modules/art/blender.nix

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  cfg = config.blender;
in
{
  options.blender.enable = lib.mkEnableOption "Enable Blender";
  config = lib.mkIf cfg.enable {
    home.packages = [ inputs.blender.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
