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
	};
}
