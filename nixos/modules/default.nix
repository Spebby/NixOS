# /nixos/modules/default.nix

{
	imports = [
		./audio.nix
		./bluetooth.nix
		./boot.nix
		./cxx.nix
		./env.nix
		./home-manager.nix
		./hyprland.nix
		./net.nix
		./nh.nix
		./nix.nix
		./timezone.nix
		./users.nix
		./zram.nix
	];
}
