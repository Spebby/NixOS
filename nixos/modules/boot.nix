# /nixos/modules/boot.nix

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
    };
  };
  boot.tmp.cleanOnBoot = true;
}
