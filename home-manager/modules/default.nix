# /home-manager/modules/default.nix

{
  imports = [
    ./hyprland
    ./stylix

    ./alacritty.nix
    ./ghostty.nix
    ./bat.nix
    ./discord.nix
    ./eza.nix
    ./firefox.nix
    ./lazygit.nix
    ./moo.nix
    ./obsidian.nix
    ./protonge.nix
    ./qt.nix
    ./starship.nix
    ./todoist.nix
    ./yazi.nix
    ./zathura.nix
    ./zsh.nix

    # Unity
    ./rider.nix
    ./unity.nix
  ];
}
