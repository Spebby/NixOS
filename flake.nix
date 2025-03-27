# /flake.nix

{
	# This may not be the best way of doing this; at some point it may make more sense to move system to be controlled by the systems, but this makes more sense for the moment.
	description = "NixOS Config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
		nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

		# Dots
		home-manager = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Theming Manager
		stylix = {
			url = "github:danth/stylix/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		hyprland.url = "github:hyprwm/Hyprland";
		hyprland-plugins = {
			url = "github:hyprwm/hyprland-plugins";
			inputs.hyprland.follows = "hyprland";
		};

		# I'm not stupid, so I won't be doing nixvim... yet
	};

	outputs = { self, nixpkgs, nixos-hardware, nix-flatpak, home-manager, stylix, hyprland, ... }@inputs: let
		# In the future, I'd like to make this dynamic discovery. But for the moment, that's really dumb when there's only 1 system and 2 users.
		lib = nixpkgs.lib;
		stateVersion = "24.11";
		hosts      = import ./hosts/hosts.nix;
		makeSystem = import ./lib/makeSystem.nix { inherit inputs stateVersion; };
		makeHome   = import ./lib/makeHome.nix   { inherit inputs stateVersion lib; };
	in {
		nixosConfigurations = builtins.mapAttrs (name: host: makeSystem host) hosts;
		homeConfigurations  = builtins.foldl' (acc: host:
			acc // builtins.foldl' (userAcc: user:
				let
					hostHMConfig = host.config.home-manager.users.${user} or {};
				in userAcc // {
					"${user}@${host.hostname}" = makeHome {
						inherit inputs user;
						pkgs = nixpkgs.legacyPackages.${host.system};
						hostModules = [ hostHMConfig ];
					};
				}
			) acc (host.users or [])
		) {} (builtins.attrValues hosts);
	};
}
