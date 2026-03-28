{
  pkgs,
  ...
}:

let
  maple-bg = pkgs.runCommand "maple-bg.jpg" { } ''
    cp ${../../../backgrounds/maple.jpg} $out
  '';
  winter-bg = pkgs.runCommand "winter-bg.mp4" { } ''
    cp ${../../../backgrounds/winter-forest-snow-moewalls-com.mp4} $out
  '';
  winter-placeholder = pkgs.runCommand "winter-placeholder.png" { } ''
    cp ${../../../backgrounds/winter-forest-placeholder.png} $out
  '';
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
    theme = "default";
    extraBackgrounds = [
      maple-bg
      winter-bg
      grass-bg
      winter-placeholder
      grass-placeholder
    ];
    themeOverrides = {
      "General" = {
        scale = "1.5";
        enable-animations = true;
        background-fill-mode = "fill";
        animated-background-placeholder = "${winter-placeholder.name}";
      };
      "LoginScreen" = {
        background = "${winter-bg.name}";
        animated-background-placeholder = "${winter-placeholder.name}";
      };
      "LockScreen" = {
        background = "${winter-bg.name}";
        animated-background-placeholder = "${winter-placeholder.name}";
        blur = "1";
      };
      "LoginScreen.MenuArea.Session".position = "bottom-left";
    };
  };
}
