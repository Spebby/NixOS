# /home-manager/modules/emulators/default.nix

{ pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [ rmg ];
}
