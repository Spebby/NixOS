{ inputs, den, ... }:
{
  den.aspects.rosso.includes = [ (den.provides.tty-autologin "thom") ];

  perSystem =
    { pkgs, ... }:
    {
      packages.vmRosso = pkgs.writeShellApplication {
        name = "vmRosso";
        text =
          let
            host = inputs.self.nixosConfigurations.rosso.config;
          in
          ''
            ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
          '';
      };
    };
}
