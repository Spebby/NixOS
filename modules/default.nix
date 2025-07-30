# /modules/default.nix
{
  inputs,
  user,
  lib,
  pkgs,
  ...
}:

let
  nixvim-stylix = nixvim.packages.${pkgs.system}.default;
  inherit (inputs) nixvim;
in
{
  home = {
    username = user;
    homeDirectory = "/home/${user}";

    sessionVariables = {
      EDITOR = lib.getExe nixvim-stylix;
      NIXOS_OZONE_WL = "1";
    };
  };

  # Blanket import everything. The user's configuration in
  # ../users/home-manager/ will enable the specific packages
  # they actually want.
  imports = [
    ./art
    ./de
    ./development
    ./discord
    ./emulators
    ./firefox
    ./productivity
    ./steam
    ./stylix
    ./terminals

    ./qt.nix
  ];
}
