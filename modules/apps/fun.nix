{ lib, ... }:
{
  my.apps._.fun = {
    provides =
      { pkgs, ... }:
      {
        terminal.nixos = {
          environment.systemPackages = with pkgs; [
            cowsay
            cbonsai
            sl
            fortune
            asciiquarium-transparent
            cmatrix
            xcowsay
            yes
            toilet
            oneko
            aalib
            rig
          ];
        };

        graphical.nixos = {
          environment.systemPackages = with pkgs; [ mesa-demos ];
        };
      };

    homeManager =
      { config, pkgs, ... }:
      let
        cfg = config.my.apps._.fun;
      in
      {
        options.my.apps._.fun = {
          includeMicrofetch = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install microfetch in the home profile.";
          };
          includeSilicon = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install silicon for code image rendering.";
          };
        };

        config.home.packages =
          (lib.optionals cfg.includeMicrofetch [ pkgs.microfetch ])
          ++ (lib.optionals cfg.includeSilicon [ pkgs.silicon ]);
      };
  };
}
