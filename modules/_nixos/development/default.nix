{ pkgs, ... }:

{
  imports = [ ./../../_overlays/amulet.nix ];

  environment.systemPackages = with pkgs; [
    raylib
    wayland-scanner
  ];
}
