# /lib/makeSystem.nix
{ inputs, stateVersion, ... }:

# Receives the full host configuration as argument
{
  hostname,
  system ? "x86_64-linux",
  config ? import ./hosts/${hostname}/configuration.nix,
  extraModules ? [ ],
  ...
}:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit inputs hostname stateVersion;
    inherit (inputs) nixos-hardware;
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  };

  modules = [ config ] ++ extraModules;
}
