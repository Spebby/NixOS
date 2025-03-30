# /home-manager/modules/default.nix

{
  imports = [
    ./hyprland
    ./swaync
    ./waybar
    ./wofi

    ./alacritty.nix
    ./bat.nix
    ./discord.nix
    ./eza.nix
    ./firefox.nix
    ./lazygit.nix
    ./moo.nix
    ./neovim.nix
    ./obsidian.nix
    ./protonge.nix
    ./qt.nix
    ./starship.nix
    ./stylix.nix
    ./todoist.nix
    ./yazi.nix
    ./zathura.nix
    ./zsh.nix
  ];
}
