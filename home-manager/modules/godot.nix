# /home-manager/modules/godot.nix

{ pkgs, pkgs-unstable, ... }:

let
  godotMono = pkgs-unstable.godot-mono;
in
{
  home.packages = [ godotMono ];

  xdg.dataFile."applications/godot-mono.desktop".text = ''
    ${pkgs.gnused}/bin/sed -i 's|^Exec=.*|Exec=${godotMono}/bin/godot-mono --single-window %F|' $out
  '';
}
