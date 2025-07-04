# /nixos/modules/cxx.nix

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    acpid # Arguable if needs to be here

    cowsay
    gparted
    ncdu
    lsof
    pciutils
    psmisc
    udisks
    glxinfo
    lshw-gui

    usbutils
    # Consider Toybox
  ];
}
