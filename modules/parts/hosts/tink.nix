{
  self,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  hostname = "tink";
  stateVersion = "24.11";

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "dotnet-sdk-6.0.428"
        "dotnet-runtime-6.0.36"
      ];
    };
  };
in
{
  flake = {
    nixosModules.tinkConfiguration = import ../../hosts/tink/configuration.nix;

    nixosModules.tink = {
      imports = [
        self.nixosModules.host-common
        self.nixosModules.silent-sddm
        self.nixosModules.silent-sddm-tink
        self.nixosModules.tinkConfiguration
      ];
    };

    nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.home-manager.nixosModules.default
        {
          _module.args = {
            inherit
              inputs
              stateVersion
              hostname
              pkgs-stable
              ;
          };
        }
        self.nixosModules.tink
      ];
    };
  };
}
