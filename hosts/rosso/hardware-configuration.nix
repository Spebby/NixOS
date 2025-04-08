# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
    extraModulePackages = [ ];
  };

  fileSystems = {
    # NIXBOOT
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    # ROOT
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };

    # HOME
    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "ext4";
    };

    # NIX
    "/nix" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "noatime" ];
    };
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 32 * 1024;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
