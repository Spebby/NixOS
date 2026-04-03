{ lib, config, ... }:
{
  my.apps._.dev.provides.odin.nixos =
    { pkgs, ... }:
    let
      cfg = config.my.apps._.dev.odin;
    in
    {
      options.my.apps._.dev.odin = {
        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional Odin-related packages to install.";
        };
      };

      config = {
        environment.systemPackages = [ pkgs.odin ] ++ cfg.extraPackages;
      };
    };
}
