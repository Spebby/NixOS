{
  my.apps._.qt.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        papirus-icon-theme
        pcmanfm-qt
        adwaita-qt
        libsForQt5.qt5.qtquickcontrols
        libsForQt5.qt5.qtgraphicaleffects
      ];

      home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";

      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style = {
          package = pkgs.adwaita-qt;
          name = "adwaita-dark";
        };
      };
    };
}
