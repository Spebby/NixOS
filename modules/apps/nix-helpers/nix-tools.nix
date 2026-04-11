{ inputs, ... }:
{
  my.apps._.nix-tools = {
    homeManager =
      { config, pkgs, ... }:
      {
        programs.nh = {
          enable = true;
          osFlake = "${config.home.homeDirectory}/.flake";
        };

        home.packages = with pkgs; [
          deadnix
          nix-init
          nix-inspect
          nix-output-monitor
          nixpkgs-review
          nix-tree
          nix-update
          nix-prefetch
          nix-prefetch-git
          nurl
          statix
          vulnix
          nixfmt
          inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien
        ];
      };
  };
}
