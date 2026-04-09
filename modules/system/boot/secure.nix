{ inputs, lib, ... }:
{
  my.boot.provides = {
    secure.nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

        environment.systemPackages = [ pkgs.sbctl ];

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
