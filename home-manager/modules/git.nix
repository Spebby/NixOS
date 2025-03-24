# /home-manager/modules/git.nix

{
	programs.git = {
		enable = true;
		userName = "Thom Mott";
		userEmail = "thommott@proton.me";

		extraConfig.init.defaultBranch = "main";
	};
}
