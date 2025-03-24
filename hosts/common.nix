# /hosts/common.nix

{ inputs, config, pkgs, ... }:

let
	syncthingDir = "/var/lib/syncthing/";
in {
	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	environment.systemPackages = with pkgs; [
		wget
		git
		home-manager
	];

	programs.zsh.enable = true;

	services.flatpak.enable = true;

	security.doas = {
		enable = true;
		extraRules = [
			{
				keepEnv = true;
				groups = [ "wheel" ];
				noPass = true;
			}
		];
	};
}
