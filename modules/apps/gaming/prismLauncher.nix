{
  my.apps._.prismlauncher.provides = {
    nixos = {
      networking = {
        # Allow connections from devices on local network (for purposes of LAN)
        firewall = {
          extraCommands = ''
            iptables -A nixos-fw -p tcp --source 192.168.0.0/24 --dport 1714:65535 -j nixos-fw-accept
            iptables -A nixos-fw -p udp --source 192.168.0.0/24 --dport 1714:65535 -j nixos-fw-accept
          '';
          extraStopCommands = ''
            iptables -D nixos-fw -p tcp --source 192.168.0.0/24 --dport 1714:65535 -j nixos-fw-accept || true
            iptables -D nixos-fw -p udp --source 192.168.0.0/24 --dport 1714:65535 -j nixos-fw-accept || true
          '';
        };
      };
    };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ prismlauncher ];
      };
  };
}
