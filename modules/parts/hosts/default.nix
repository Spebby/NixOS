{ self, lib, ... }:
let
  defaultHostBySystem = {
    x86_64-linux = "rosso";
  };
in
{
  perSystem =
    { system, ... }:
    let
      defaultHost = defaultHostBySystem.${system} or null;
    in
    lib.optionalAttrs (defaultHost != null && builtins.hasAttr defaultHost self.nixosConfigurations) {
      packages.default = self.nixosConfigurations.${defaultHost}.config.system.build.toplevel;
    };
}
