# /hosts/rosso/configuration.nix

{ pkgs, lib, stateVersion, hostname, nixos-hardware, ... }:

{	networking.hostName = hostname;
	system.stateVersion = stateVersion;

	imports = [
		./hardware-configuration.nix
		./local-packages.nix
		../common.nix		# Common to hosts
		../../nixos/modules # Global modules
		nixos-hardware.nixosModules.lenovo-legion-16ach6h
	];

	environment = {
		systemPackages = [
			pkgs.home-manager
			pkgs.bottles
		];

		sessionVariables = {
			NIXOS_OZONE_WL = "1";
		};
	};

	# Hyperland Specific
	programs.hyprland = {
		enable = true;

		# These two are sometimes nice but I don't want em' for now
		# withUWSM = true;
		# xwayland.enable = false;
	};
	security.pam.services.hyprlock = {};

	users.defaultUserShell = pkgs.zsh;
	users.users = {
		thom = {
			isNormalUser = true;
			home = "/home/thom";
			extraGroups = [
				"wheel"
				"networkmanager"
				"home-manager"
			];
		};
		max = {
			isNormalUser = true;
			home = "/home/max";
			extraGroups = [
				"wheel"
				"networkmanager"
				"home-manager"
			];
		};
	};

	home-manager.sharedModules = [{
		home.stateVersion = stateVersion;
	}];
	home-manager.users = {
		thom = {
			home.packages = lib.mkAfter (with pkgs; [
				# System-specific user packages
				mangohud
				lutris
			]);
		};

		max = {
			home.packages = lib.mkAfter (with pkgs; [
				neofetch
			]);
		};
	};

	services.getty = {
		greetingLine = "moo";
		# autoLoginUser = user;
	};
}
