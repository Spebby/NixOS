# /home-manager/modules/emulators/default.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [ rmg ];
}
