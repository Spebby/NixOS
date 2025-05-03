# /home-manager/default.nix

{
  inputs,
  user,
  stateVersion,
  lib,
  pkgs,
  ...
}:

let
  nixvim-stylix = nixvim.packages.${pkgs.system}.default;
  inherit (inputs) nixvim;
in
{
  imports = [
    ./modules
    ./home-packages.nix
    #./flatpak.nix
  ];

  home.stateVersion = stateVersion;
  home = {
    username = user;
    homeDirectory = "/home/${user}";

    sessionVariables = {
      EDITOR = lib.getExe nixvim-stylix;
      NIXOS_OZONE_WL = "1";
    };
  };
}
