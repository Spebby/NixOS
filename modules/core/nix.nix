{ inputs, ... }: {
  den.default = {
    nixos = {
      imports = [ inputs.nix-index-database.nixosModules.nix-index ];
      nixpkgs.config.allowUnfree = true;
      programs = {
        command-not-found.enable = false;
        direnv.enable = true;
        nix-index-database.comma.enable = true;
        nix-ld.enable = true;
      };

      nix = {
        optimise.automatic = true;
        registry = {
          nixpkgs.flake = inputs.nixpkgs;
          nixpkgs-stable.flake = inputs.nixpkgs-stable;
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
          persistent = true;
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
        };
      };
    };

    homeManager = {
      #quix config if you want it

      nix = {
        registry = {
          nixpkgs.flake = inputs.nixpkgs;
          nixpkgs-stable.flake = inputs.nixpkgs-stable;
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
          persistent = true;
        };
      };
    };
  };
}
