# /home-modules/modules/zsh.nix

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.terminals.zsh;
in
{
  options.terminals.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ZSH shell config";
    };

    enableCompletion = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    services.cliphist.enable = true;
    fonts.fontconfig.enable = true;

    programs.zsh = {
      inherit (cfg) enable enableCompletion;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        #nix-sw = "nh os switch";
        #nix-upd = "nh os switch --update";
        #nix-hms = "nh home switch";
        #pkgs = "nvim ${flakeDir}/nixos/packages.nix";

        microfetch = "microfetch && echo";
        ".." = "cd ..";

        vim = lib.getExe inputs.nixvim.packages.${pkgs.system}.default;
        ls = "eza --group-directories-first --icons";
        cat = "bat";
        lf = "${config.programs.yazi.shellWrapperName}";
        grep = "rg";
        grepchild = "grep -rnwe";

        firefox = "exec firefox";
        xev = "wev";
      };

      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";

      # it may be worth eventually translating over the vicmd and zle-keymap stuff in the old config
      initContent = ''
        	# If I ever start using TMUX or  UWSM, put it here.
      '';

      # There is for sure a better way of doing this
      #profileExtra = ''
      #if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
      #	Hyprland > /dev/null
      #fi
      #'';
    };
  };
}
