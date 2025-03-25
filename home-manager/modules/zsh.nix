# /home-modules/modules/zsh.nix

{ config, ... }:

{
	services.cliphist.enable = true;
	fonts.fontconfig.enable  = true;

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases =
		let			
			flakeDir = "~/flake";
		in {
			nix-sw  = "nh os switch";
			nix-upd = "nh os switch --update";
			nix-hms = "nh home switch";
			#pkgs = "nvim ${flakeDir}/nixos/packages.nix";

			microfetch = "microfetch && echo";
			".." = "cd ..";

			vim = "nvim";
			ls  = "eza --group-directories-first --icons";
			cat = "bat";
			lf  = "${config.programs.yazi.shellWrapperName}";
			grep = "rg";

			obsidian = "hyprctl dispatch killactive && hyprctl dispatch exec \"obsidian\"";
			discord = "hyprctl dispatch killactive && hyprctl dispatch exec \"discord\"";
			firefox = "exec firefox";
		};

		history.size = 10000;
		history.path = "${config.xdg.dataHome}/zsh/history";

		# it may be worth eventually translating over the vicmd and zle-keymap stuff in the old config
		initExtra = ''
			# If I ever start using TMUX or  UWSM, put it here.

			moo() {
				echo -e "$(shuf -n 1 .local/store/moo)"
			}
		'';

		# There is for sure a better way of doing this
		profileExtra = ''
			if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
				Hyprland > /dev/null
			fi
		'';
	};
}
