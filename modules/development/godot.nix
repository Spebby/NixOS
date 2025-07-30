# /home-manager/modules/godot.nix

{ pkgs, ... }:

let
  godotMono = pkgs.godot-mono;
in
{
  home.packages = [ godotMono ];

  xdg.dataFile."applications/godot-mono.desktop".text = ''
    ${pkgs.gnused}/bin/sed -i 's|^Exec=.*|Exec=${godotMono}/bin/godot-mono --single-window %F|' $out
  '';
}
