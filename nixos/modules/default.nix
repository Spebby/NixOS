# /nixos/modules/default.nix

{
	imports = [
		./audio.nix
		./bluetooth.nix
		./boot.nix
		./cxx.nix
		./env.nix
		./home-manager.nix
		./net.nix
		./nix.nix
		./timezone.nix
		./zram.nix
	];
}
