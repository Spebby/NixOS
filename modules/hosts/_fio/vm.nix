{ inputs, den, ... }: {
  den.aspects.fio.includes = [ (den.provides.tty-autologin "thom") ];

  perSystem = { lib, pkgs, ... }: {
    packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      vmFio = pkgs.writeShellApplication {
        name = "vmFio";
        text =
          let
            host = inputs.self.nixosConfigurations.fio.config;
          in
          ''
            ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
          '';
      };
    };
  };
}
