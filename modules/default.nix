# /home-manager/modules/default.nix

{
  imports = [
    ./hyprland
    ./emulators
    ./terminals

    # Styling
    ./stylix
    ./qt.nix

    ./bat.nix
    ./blender.nix
    ./discord.nix
    ./eza.nix
    ./firefox.nix
    ./lazygit.nix
    ./moo.nix
    ./obsidian.nix
    ./protonge.nix
    ./starship.nix
    ./todoist.nix
    ./yazi.nix
    ./zathura.nix
    ./zsh.nix
    #    ./dolphin.nix

    # Unity
    ./rider.nix
    ./unity.nix
    ./godot.nix
  ];
}
