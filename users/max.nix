{ pkgs, ... }:

{
	users = {
		users.max = {
			isNormalUser = true;
			home = "/home/max";
			extraGroups = [
				"wheel"
				"networkmanager"
				"home-manager"
			];
		};
	};
}
