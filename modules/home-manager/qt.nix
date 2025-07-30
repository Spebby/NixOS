# /home-manager/modules/qt.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    papirus-icon-theme
    pcmanfm-qt
    adwaita-qt
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };
}
