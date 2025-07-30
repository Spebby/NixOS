# /lib/makeHome.nix

{
  inputs,
  stateVersion,
  lib,
}:

{
  pkgs,
  pkgs-stable,
  user,
  hostModules ? [ ],
  ...
}:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  inherit lib;

  modules = [
    ../modules
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
      pkgs-stable
      ;
  };
}
