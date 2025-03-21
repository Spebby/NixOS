{ pkgs, ... }:

{
	nixpkgs.config.allowUnfree = true;

	# Packages I don't have specific configs for
	home.packages = with pkgs; [
		# Desktop Apps
		firefox
		mpv
		obs-studio
		obsidian
		
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
		gnu-netcat	
		gparted
		grimblast
		htop
		hyprpicker
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

		# CXX
		gcc
		clang
		clang-format
		make
		cmake

		# CXX - Adj
		meson
		cpio

		# ECMA
		nodejs
		npm

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
