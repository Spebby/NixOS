# /lib/makeHome.nix

{
  inputs,
  stateVersion,
  lib,
}:

{
  pkgs,
  user,
  hostModules ? [ ],
  ...
}@args:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    ../home-manager
    ../users/home-manager/${user}.nix
    (
      { lib, ... }:
      {
        home.stateVersion = lib.mkDefault stateVersion;
      }
    )
  ];

  extraSpecialArgs = { inherit inputs user stateVersion; };
}
