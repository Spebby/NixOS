{
  pkgs,
  ...
}:

let
  grass-bg = pkgs.runCommand "grass-bg.mp4" { } ''
    cp ${../../../backgrounds/wavy-grass-moewalls-com.mp4} $out
  '';
  grass-placeholder = pkgs.runCommand "grass-placeholder.png" { } ''
    cp ${../../../backgrounds/wavy-grass-placeholder.png} $out
  '';

in
{
  silentSDDM = {
    enable = true;
    theme = "rei";
    extraBackgrounds = [
      grass-bg
      grass-placeholder
    ];
    themeOverrides = {
      "General" = {
        scale = "1.0";
        enable-animations = true;
        background-fill-mode = "fill";
        animated-background-placeholder = "${grass-placeholder.name}";
      };
      "LoginScreen" = {
        background = "${grass-bg.name}";
        animated-background-placeholder = "${grass-placeholder.name}";
      };
      "LockScreen" = {
        background = "${grass-bg.name}";
        animated-background-placeholder = "${grass-placeholder.name}";
      };
      "LoginScreen.MenuArea.Session".position = "bottom-left";
    };
  };
}
