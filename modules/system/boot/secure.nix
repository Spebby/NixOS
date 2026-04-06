{ inputs, lib, ... }:
{
  my.boot.provides = {
    secure.nixos = {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        loader = {
          systemd-boot.enable = lib.mkForce false; # Disable, as Lanzaboote replaces
          grub.enable = lib.mkForce false;
          efi.canTouchEfiVariables = true;
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
