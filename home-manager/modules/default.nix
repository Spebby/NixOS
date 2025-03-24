# /home-manager/modules/default.nix

{
	imports = [
		./hyprland
		./swaync
		./waybar
		./wofi

		./bat.nix
		./eza.nix
		./firefox.nix
		./git.nix
		./lazygit.nix
		./neovim.nix
		./obsidian.nix
		./qt.nix
#		./ranger.nix
		./starship.nix
#		./steam.nix
		./stylix.nix
		./zathura.nix
		./zsh.nix
	];
}
