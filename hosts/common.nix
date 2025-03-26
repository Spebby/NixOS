# /hosts/common.nix

{ inputs, config, pkgs, ... }:

let
	syncthingDir = "/var/lib/syncthing/";
in {
	# TODO: move the theme specific stuff to machine specific configs.
	# I also like owl, Loader 2, Spinner Alt, Splash, Cuts Alt, DNA, Hexagon Dots Alt, Hexagons
	boot = {
		plymouth = {
			enable = true;
			theme  = "cuts_alt";
			themePackages = with pkgs; [
				# By default we would install all themes
				(adi1090x-plymouth-themes.override {
					selected_themes = [ "cuts_alt" ];
				})
			];
		};

		# Silent Boot
		consoleLogLevel = 0;
		initrd.verbose = false;
		kernelParams = [
			"quiet"
			"splash"
			"boot.shell_on_fail"
			"loglevel=3"
			"rd.systemd.show_status=false"
			"rd.udev.log_level=3"
			"udev.log_priority=3"
		];	
		# Hide OS choice for bootloader
		# loader.timeout = 0;
	};



	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	environment.systemPackages = with pkgs; [
		git
		home-manager
		openssl
		wget
	];

	programs.zsh.enable = true;

	services.flatpak.enable = true;
	services.gvfs.enable = true;    # Mount, trash, etc
	services.tumbler.enable = true; # Thumbnail support for images

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
