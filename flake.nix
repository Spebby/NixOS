# /flake.nix

# This is just a slightly modified version of Andrey0189's nixos-config-reborn flake.nix file
# which was done very, very well

{
	description = "NixOS Config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

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

		# Potentially moving these into their own user controlled areas would be best.
		hyprland.url = "github:hyprwm/Hyprland";
		hyprland-plugins = {
			url = "github:hyprwm/hyprland-plugins";
			inputs.hyprland.follows = "hyprland";
		};
		split-monitor-workspaces = {
			url = "github:Duckonaut/split-monitor-workspaces";
			inputs.hyprland.follows = "hyprland";
		};

		# I'm not stupid, so I won't be doing nixvim... yet
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
		nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
	};

	outputs = { self, nixpkgs, home-manager, hyprland, nixos-hardware, nix-flatpak, ... }@inputs: let
	system = "x86_64-linux";
	homeStateVersion = "24.11";
	user = "thom";
	hosts = [
		{
			hostname = "rosso";
			stateVersion = "24.11";
		}
	];


	# Nix Builder
	makeSystem = { hostname, stateVersion }: nixpkgs.lib.nixosSystem {
		system = system;
		specialArgs = {
			inherit inputs stateVersion hostname user;
		};

		modules = [
			nix-flatpak.nixosModules.nix-flatpak
			./hosts/${hostname}/configuration.nix
		];
	};

	in {
		nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
			configs // {
			"${host.hostname}" = makeSystem {
				inherit (host) hostname stateVersion;
			};
		}) {} hosts;

		homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.${system};
			extraSpecialArgs = {
				inherit inputs homeStateVersion user hyprland nix-flatpak;
			};

			modules = [
				./home-manager/home.nix
			];
		};
	};
}
