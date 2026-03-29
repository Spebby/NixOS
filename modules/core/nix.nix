{ inputs, ... }:
{
  den.default = {
    nixos = {
      imports = [ inputs.nix-index-database.nixosModules.nix-index ];
      nixpkgs.config.allowUnfree = true;
      programs = {
        nix-index-database.comma.enable = true;
        nix-ld.enable = true;
      };
      nix = {
        optimise.automatic = true;
        registry.nixpkgs.flake = inputs.nixpkgs;
        settings = {
          #keep-outputs = true;
          #keep-derivations = true;
          #use-xdg-base-directories = true;
          auto-optimise-store = true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };
    };
    homeManager = {
      #quix config if you want it
    };
  };
}
