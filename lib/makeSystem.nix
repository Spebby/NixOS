# /lib/makeSystem.nix
{ inputs, stateVersion, ... }:

# Receives the full host configuration as argument
{ hostname
, system ? "x86_64-linux"
, config ? import ./hosts/${hostname}/configuration.nix
, extraModules ? []
, ...
}@host:

inputs.nixpkgs.lib.nixosSystem {
	inherit system;
  
	specialArgs = {
		inherit inputs hostname stateVersion;
		nixos-hardware = inputs.nixos-hardware;
	};

	modules = [
		config
	] ++ extraModules;
}
