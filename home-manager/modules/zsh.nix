# /home-modules/modules/zsh.nix

{ config, ... }: {
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
			ls  = "exa --icons";
			cat = "bat";
			grep = "rg";
			lf  = "ya-with-dir-change";

			obsidian = "hyprctl dispatch killactive && hyprctl dispatch exec \"obsidian\"";
			discord = "hyprctl dispatch killactive && hyprctl dispatch exec \"discord\"";
			firefox = "exec firefox";			
		};

		history.size = 10000;
		history.path = "${config.xdg.dataHome}/zsh/history";

		# it may be worth eventually translating over the vicmd and zle-keymap stuff in the old config
		initExtra = ''
			function ya-with-dir-change() {
				local tmp = "$(mktemp -t "yazi-cwd.XXXXX")"
				yazi "$@" --cwd-file="$tmp"
				if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWPD" ]; then
					cd -- "$cwd"
				fi
				rm -f -- "$tmp"
			}

			# If I ever start using TMUX or  UWSM, put it here.
		'';
	};
}
