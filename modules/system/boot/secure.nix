{ inputs, lib, ... }:
{
  my.boot.provides = {
    secure.nixos = {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        loader = {
          systemd-boot.enable = lib.mkForce false;
          grub.enable = lib.mkForce false;
        };

        tmp.cleanOnBoot = true;

        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };
  };
}
