{ lib, config, ... }:
{
  my.apps._.dev.provides.zig.nixos =
    { pkgs, ... }:
    let
      cfg = config.my.apps._.dev.zig;
    in
    {
      options.my.apps._.dev.zig = {
        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional Zig-related packages to install.";
        };
      };

      config = {
        environment.systemPackages = [ pkgs.zig ] ++ cfg.extraPackages;
      };
    };
}
