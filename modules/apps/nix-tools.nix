{ inputs, ... }:
{
  my.apps._.nix-tools = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          deadnix
          nix-init
          nix-inspect
          nix-output-monitor
          nixpkgs-review
          nix-tree
          nix-update
          nurl
          statix
          vulnix
          nixfmt
          inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien
        ];
      };
  };
}
