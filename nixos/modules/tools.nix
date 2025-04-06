# /nixos/modules/cxx.nix

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    acpid # Arguable if needs to be here

    gparted
    ncdu
    lsof
    udisks
  ];
}
