# review docs
{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports for Steam Remote Play
		dedicatedServer.openFirewall = true; # open ports for Source Dedicated Server
		localNetworkGameTransfers.openFirewall = true; # Open ports for Steam Local Network
	};

	nixpkgs.config.allowUnFreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"steam"
		"steam-original"
		"steam-unwrapped"
		"steam-run"
	];
}
