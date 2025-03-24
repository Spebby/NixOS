# /home-manager/flatpak.nix

{ config, nix-flatpak, ... }:

{
	imports = [
		nix-flatpak.homeManagerModules.nix-flatpak
	];

	services.flatpak.remotes = [
		{
			name = "flathub";
			location = "https://flathub.org/repo/flathub.flatpakrepo";
		}
		{
			name = "flathub-beta"; 
			location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
		}
	];

	services.flatpak.update.auto = {
		enable = true;
		onCalendar = "weekly";
	};

	services.flatpak.packages = [
		{ appId = "com.unity.UnityHub"; origin = "flathub";  }
	];
}
