# /lib/makeHome.nix

{
  inputs,
  stateVersion,
  lib,
}:

{
  pkgs,
  pkgs-unstable,
  user,
  hostModules ? [ ],
  ...
}:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  inherit lib;

  modules = [
    ../home-manager
    ../users/home-manager/${user}.nix
    (
      { lib, ... }:
      {
        home.stateVersion = lib.mkDefault stateVersion;
      }
    )
  ] ++ hostModules;

  extraSpecialArgs = {
    inherit
      inputs
      user
      stateVersion
      pkgs-unstable
      ;
  };
}
