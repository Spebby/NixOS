{ inputs, ... }:
{
  den.default = {
    nixos = {
      imports = [ inputs.nix-index-database.nixosModules.nix-index ];
      programs = {
        direnv.enable = true;
        nix-index-database.comma.enable = true;
        nix-ld.enable = true;
      };

      nixpkgs.config = {
        allowUnfree = true;
        cudaSupport = false;
      };

      nix = {
        optimise.automatic = true;
        registry.nixpkgs.flake = inputs.nixpkgs;

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };

        settings = {
          #keep-outputs = true;
          #keep-derivations = true;
          #use-xdg-base-directories = true;
          auto-optimise-store = true;

          experimental-features = [
            "nix-command"
            "flakes"
          ];

          substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org/"
            "https://cuda-maintainers.cachix.org/"
            "https://cosmic.cachix.org/"
          ];

          trusted-substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org/"
            "https://cuda-maintainers.cachix.org/"
            "https://cosmic.cachix.org/"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
            "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          ];
        };
      };
    };

    homeManager = {
      #quix config if you want it
    };
  };
}
