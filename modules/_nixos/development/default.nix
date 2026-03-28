{ pkgs, ... }:

{
  imports = [ ./../../overlays/amulet.nix ];

  environment.systemPackages = with pkgs; [
    raylib
    wayland-scanner
  ];
}
