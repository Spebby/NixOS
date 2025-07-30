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
  options.blender.enable = lib.mkIf cfg.enable {
    home.packages = [ inputs.blender.packages.${pkgs.system}.default ];
  };
}
