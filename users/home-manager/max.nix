# /users/home-manager/max.nix

{ pkgs, ... }:

{
	home.packages = with pkgs; [
		neofetch
	];

	programs.git = {
		enable = true;
		userName = "Max Brockmann";
		userEmail = "max.marika.brock@gmail.com";
		extraConfig.init.defaultBranch = "main";
	};
}
