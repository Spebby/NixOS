{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a023f4b0-2216-4b6d-9001-81def0686bbe";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/56F3-642C";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/53bfe944-4393-4694-a57e-593c5d8e0cb6";
      fsType = "ext4";
    };

    "/mnt/vaults" = {
      device = "/dev/disk/by-uuid/0c476c22-af86-417a-9667-dd23a092f85d";
      fsType = "ext4";
    };

    "/home/max/Vault" = {
      device = "/mnt/vaults/max";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  systemd.tmpfiles.rules = [ "d /mnt/vaults/max 0700 max users - -" ];

  swapDevices = [ { device = "/dev/disk/by-uuid/5fae22da-fde4-4603-9ce9-ba65f78d63c5"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
