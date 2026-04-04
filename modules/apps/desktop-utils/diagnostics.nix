{
  my.apps._.diagnostics.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gparted
        ncdu
        lsof
        pciutils
        lshw-gui
        usbutils
        edid-decode
        wget
        mission-center
        udisks
      ];
    };
}
