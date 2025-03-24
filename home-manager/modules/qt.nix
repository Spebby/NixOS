# /home-manager/modules/qt.nix

{ pkgs, ... }:

{
	home.packages = with pkgs; [
		papirus-icon-theme
		pcmanfm-qt
	];

	qt = {
		enable = true;
		platformTheme.name = "qtk";
		style = {
			package = pkgs.adwaita-qt;
			name = "adwaita-dark";
		};
	};
}
