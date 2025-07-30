# /home-manager/packages/blender.nix

{ pkgs, inputs, ... }:

{
  home.packages = [ inputs.blender.packages.${pkgs.system}.default ];
}
