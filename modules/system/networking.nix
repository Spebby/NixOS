{
  my.networking = {
    provides = {
      static.nixos = {
        networking.tempAddresses = "disabled";
      };

      wol.nixos = {
        systemd.network.links."50-wol" = {
          matchConfig.Type = "ether";
          linkConfig.WakeOnLan = "magic";
        };
      };

    };
    nixos = {
      networking = {
        networkmanager.enable = true;
        nftables.enable = true;
        wireguard.enable = true;
        firewall.trustedInterfaces = [
          "virbr0"
          "podman0"
          "docker0"
        ];
      };
    };
  };
}
