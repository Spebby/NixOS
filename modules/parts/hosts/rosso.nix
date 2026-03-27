{
  self,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  hostname = "rosso";
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
    nixosModules.rossoConfiguration = import ../../hosts/rosso/configuration.nix;

    nixosModules.rosso = {
      imports =
        map (name: inputs.nixos-hardware.nixosModules.${name}) [
          "common-cpu-amd"
          "common-cpu-amd-pstate"
          "common-cpu-amd-zenpower"
          "common-gpu-amd"
          "common-pc-laptop"
          "common-pc-ssd"
        ]
        ++ [
          self.nixosModules.host-common
          self.nixosModules.silent-sddm
          self.nixosModules.silent-sddm-rosso
          self.nixosModules.rossoConfiguration
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
        self.nixosModules.rosso
      ];
    };
  };
}
