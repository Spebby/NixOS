{ inputs, den, ... }:
{
  den.aspects.tink.includes = [ (den.provides.tty-autologin "max") ];

  perSystem =
    { pkgs, ... }:
    {
      packages.vmTink = pkgs.writeShellApplication {
        name = "vmTink";
        text =
          let
            host = inputs.self.nixosConfigurations.tink.config;
          in
          ''
            ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
          '';
      };
    };
}
