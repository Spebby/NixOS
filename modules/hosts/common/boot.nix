{
  boot = {
    loader = {
      systemd-boot.enable = false;
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
          params = [ "onepass" ];
        };
      };
    };

    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
  };
}
