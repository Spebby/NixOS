{ pkgs, ... }:

{
  imports = [ ./amulet.nix ];

  environment.systemPackages = with pkgs; [
    raylib
    wayland-scanner
  ];
}
