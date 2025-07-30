# /home-manager/modules/godot.nix

{
  config,
  pkgs,
  lib,
}:

let
  godotMono = pkgs.godot-mono;
  cfg = config.godot;
in
{
  options.godot.enable = lib.mkEnableOption "Enable the Godot game engine";

  config = lib.mkIf cfg.enable {
    home.packages = [ godotMono ];

    xdg.dataFile."applications/godot-mono.desktop".text = ''
      ${pkgs.gnused}/bin/sed -i 's|^Exec=.*|Exec=${godotMono}/bin/godot-mono --single-window %F|' $out
    '';
  };
}
