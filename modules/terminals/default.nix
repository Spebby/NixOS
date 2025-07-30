# /modules/terminals/default.nix

{ config, lib, ... }:

let
  cfg = config.terminals;
in
{
  # Tools used inside the emulator
  imports = [
    ./bat.nix
    ./eza.nix
    ./lazygit.nix
    ./starship.nix
    ./yazi.nix
    ./zathura.nix
    ./zsh.nix
  ];

  # Emulators themselves
  config = {
    programs = {
      kitty = lib.mkIf cfg.kitty.enable {
        enable = true;
        extraConfig = ''
          confirm_os_window_close 0
        '';
      };

      alacritty = lib.mkIf cfg.alacritty.enable {
        enable = true;
        settings.font = {
          builtin_box_drawing = true;
          normal.style = lib.mkForce "Bold";
        };
      };

      ghostty = lib.mkIf cfg.ghostty.enable { enable = true; };

      zsh = lib.mkIf cfg.zsh.enable {
        enable = true;
        oh-my-zsh.enable = true;
      };
    };
  };

  # Config options
  options.terminals = {
    eza.enable = lib.mkEnableOption "Enable eza 'ls' replacement";
    starship.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Starship terminal shell prompt";
    };
    zsh.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ZSH shell and config";
    };

    alacritty.enable = lib.mkEnableOption "Enable Alacritty terminal emulator";
    ghostty.enable = lib.mkEnableOption "Enable Ghostty terminal emulator";
    kitty.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Kitty terminal emulator.";
    };

    terminals.default = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "kitty"
          "alacritty"
          "ghostty"
        ]
      );
      default = "kitty";
      description = "Preferred terminal emulator to be launched by terminal-using programs.";
    };
  };
}
