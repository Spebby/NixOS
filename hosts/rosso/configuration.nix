# /hosts/rosso/configuration.nix

{ pkgs, stateVersion, hostname, ... }:

{
	import = [
	  ./hardware-configuration.nix
	  ./local-packages.nix
	  ../../nixos/modules
	];

	environment.systemPackages = [ pkgs.home-manager ];
	networking.hostName = hostname;
	system.stateVersion = stateVersion;
}
