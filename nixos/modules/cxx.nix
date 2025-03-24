# /nixos/modules/cxx.nix

{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		clang
		gcc
		meson
		cmake
		gnumake
		cpio
		git
		binutils

		nvi
	];

	environment.variables = {
		CC  = "clang";
		CXX = "clang++";
	};
}
