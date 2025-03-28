# /home-manager/default.nix

{ user, stateVersion, ... }:

{
	imports = [
		./modules
		./home-packages.nix
		#./flatpak.nix
		#userModules
	];

	home.stateVersion = stateVersion;
	home = {
		username = user;
		homeDirectory = "/home/${user}";

		sessionVariables = {
			NIXOS_OZONE_WL = "1";
		};
	};
}
