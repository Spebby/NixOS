{ pkgs, user, ... }:

{
	users = {
		defaultUserShell = pkgs.zsh;
		users.${user} = {
			isNormalUser = true;
			extraGroups = [ "wheel" "networkmanager" ];
		};
	};
	services.getty.greetingLine = "moo";
	services.getty.autologinUser = user;
}
