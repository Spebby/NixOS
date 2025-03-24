# /home-manager/home-packages.nix

{ pkgs, ... }:

{
	nixpkgs.config.allowUnfree = true;

	# Packages I don't have specific configs for
	home.packages = with pkgs; [
		# Desktop Apps
		discord
		gimp-with-plugins
		jetbrains.rider
		libreoffice-qt6
		mpv
		obs-studio
		obsidian
		pinta
		slack
		thunderbird
		vlc
		vscode
		xfce.thunar

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
