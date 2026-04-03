{ lib, config, ... }:
{
  my.apps._.dev.provides.common.nixos =
    { pkgs, ... }:
    let
      cfg = config.my.apps._.dev.common;
    in
    {
      options.my.apps._.dev.common = {
        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional cross-language dev utilities.";
        };
      };

      config = {
        environment.systemPackages =
          with pkgs;
          [
            cpio
            binutils
            gdb
          ]
          ++ cfg.extraPackages;
      };
    };
}
