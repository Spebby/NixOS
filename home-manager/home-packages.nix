# /home-manager/home-packages.nix

{ pkgs, requireFile, ... }:

{
	nixpkgs = {
		config.allowUnfree = true;
		overlays = [
			(import ./packages)
		];
		config = {
			permittedInsecurePackages = [
				"openssl-1.1.1w"
			];
		};
	};

	# Packages I don't have specific configs for
	home.packages = with pkgs; [
		# Desktop Apps
		cider-2
		discord
		gimp-with-plugins
		jetbrains.rider
		libreoffice-qt6
		mission-center
		mpv
		obs-studio
		obsidian
		pinta
		slack
		thunderbird
		vlc
		xfce.thunar
		xfce.xfconf

		# Unity is superrrr cool and uses an old version of openssl for no good reason
		openssl_1_1
		(pkgs.unityhub.override {
			extraLibs = pkgs: with pkgs; [
				openssl_1_1
			];
		})
		verco # Plastic SCM client

		# Steam Helpers
		steam-tui
		steamcmd


		# CLI Utils
		acpid
		alsa-utils
		bat
		bc
		bottom
		brightnessctl
		cliphist
		fastfetch
		ffmpeg
		ffmpegthumbnailer
		fzf
		git-graph	
		gparted
		grimblast
		htop
		hyprpicker
		netcat-gnu
		ntfs3g
		mediainfo
		microfetch
		playerctl
		ripgrep
		showmethekey
		silicon
		tlp
		udisks
		ueberzugpp
		unzip
		w3m
		wget
		wl-clipboard
		wtype
		yt-dlp
		zip

		# CXX - Adj
		meson
		cpio

		# ECMA
		nodejs
#		npm

		python311

		# WM
		libsForQt5.xwaylandvideobridge
		libnotify
		xdg-desktop-portal-gtk
		xdg-desktop-portal-hyprland

		# Other
		bemoji
		nix-prefetch-scripts
	];
}
