{ self, inputs, ... }:
{
  flake.nixosConfigurations.rosso = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.rossoConfiguration ];
  };
}
