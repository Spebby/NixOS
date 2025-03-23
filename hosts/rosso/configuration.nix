# /hosts/rosso/configuration.nix

{ pkgs, stateVersion, hostname, ... }:

{
	imports = [
	  ./hardware-configuration.nix
	  ./local-packages.nix
	  ./../common.nix
	  ./../../nixos/modules
	];

	environment.systemPackages = [ pkgs.home-manager ];
	networking.hostName = hostname;
	system.stateVersion = stateVersion;
}
