{
  inputs,
  lib,
  ...
}:
let
  stateVersion = "24.11";

  mkStablePkgs =
    system:
    import inputs.nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "dotnet-sdk-6.0.428"
          "dotnet-runtime-6.0.36"
        ];
      };
    };

  mkHome =
    {
      user,
      system,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      inherit lib;

      modules = [
        {
          _module.args = {
            inherit inputs stateVersion;
            pkgs-stable = mkStablePkgs system;
          };

          home = {
            username = lib.mkDefault user;
            homeDirectory = lib.mkDefault "/home/${user}";
            stateVersion = lib.mkDefault stateVersion;
          };
        }
        inputs.stylix.homeModules.stylix
        inputs.hyprland-unity-fix.nixosModules.hyprlandUnityFixModule
        ../home-manager
        ../../users/home-manager/${user}.nix
      ];
    };
in
{
  flake.homeConfigurations = {
    "thom@rosso" = mkHome {
      user = "thom";
      system = "x86_64-linux";
    };
    "max@rosso" = mkHome {
      user = "max";
      system = "x86_64-linux";
    };
    "max@tink" = mkHome {
      user = "max";
      system = "x86_64-linux";
    };
  };
}
