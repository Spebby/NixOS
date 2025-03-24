# /nixos/modules/hyprland.nix

{
	#org config had 
	# meson, waybar, dunst, libnotify, swaybg, wofi, stow, swayidle, hyprshot
	programs.hyprland = {
		enable = true;

		# These two are sometimes nice but I don't want em' for now
		#withUWSM = true;
		#xwayland.enable = false;
	};

	security.pam.services.hyprlock = {};
	environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
