# /nixos/modules/boot.nix
{
  lib,
  pkgs,
  ...
}:

with lib;

let
  memtest86 = pkgs.memtest86plus;
in

{
  boot.loader = {
    systemd-boot.enable = false;

    # the "/boot" thing can probably be made more "modular" but igaf rn
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;

      memtest86 = {
        enable = false;
        package = memtest86;
        # Make Memtest86+, a memory testing program, available from the GRUB boot menu.
        params = [ "onepass" ];
      };
    };
  };
  boot.tmp.cleanOnBoot = true;
}
