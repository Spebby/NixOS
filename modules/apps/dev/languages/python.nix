{ lib, config, ... }:
{
  my.apps._.dev.provides.python.nixos =
    { pkgs, ... }:
    let
      cfg = config.my.apps._.dev.python;
    in
    {
      options.my.apps._.dev.python = {
        includeLiveServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install live-server alongside Python tools.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional Python-related packages to install.";
        };
      };

      config = {
        environment.systemPackages = [
          pkgs.python311
        ]
        ++ lib.optionals cfg.includeLiveServer [ pkgs.live-server ]
        ++ cfg.extraPackages;
      };
    };
}
