{
  my.networking = {
    provides = {
      static.nixos = {
        networking.tempAddresses = "disabled";
      };

      wol.nixos = {
        systemd.network.links."10-wol" = {
          matchConfig.Type = "ether";
          linkConfig.WakeOnLan = "magic";
        };
      };

    };
    nixos =
      { lib, ... }:
      {
        systemd.network.networks."99-ethernet-default-dhcp" = {
          networkConfig.UseDomains = "yes";
        };

        networking = {
          networkmanager.enable = true;
          networkmanager.dns = "systemd-resolved";
          nftables.enable = true;
          wireguard.enable = true;
          resolvconf.enable = false;
          useDHCP = lib.mkDefault true;
          firewall.trustedInterfaces = [
            "virbr0"
            "podman0"
            "docker0"
          ];
        };

        services.resolved.enable = true;
      };
  };
}
