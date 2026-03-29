{ inputs, lib, ... }:
{
  my.boot.provides = {
    secure.nixos = {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
      boot = {
        loader = {
          systemd-boot.enable = lib.mkForce false;
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

        tmp.cleanOnBoot = true;
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };

    graphical.nixos = {
      boot = {
        plymouth.enable = true;
        consoleLogLevel = 3;
        initrd.verbose = false;
        initrd.systemd.enable = true;
        kernelParams = [
          "quiet"
          "splash"
          "intremap=on"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];
      };
    };
  };
}
