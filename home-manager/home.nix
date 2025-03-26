{ homeStateVersion, user, ... }:

{
	imports = [
		./modules
		./home-packages.nix
		./flatpak.nix
	];

	home = {
		username = user;
		homeDirectory = "/home/${user}";
		stateVersion = homeStateVersion;

		sessionVariables = {
			NIXOS_OZONE_WL = "1";
		};
	};
}
