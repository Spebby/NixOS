{ pkgs }:

let
  hyprKillOrHideSteam = pkgs.writeShellScriptBin "hypr-kill-or-hide-steam" ''
    if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
        xdotool getactivewindow windowunmap
    else
        hyprctl dispatch killactive ""
    fi
  '';
in
{
  packages = with pkgs; [
    kitty
    xdotool
    jq
    hyprKillOrHideSteam
  ];
}
