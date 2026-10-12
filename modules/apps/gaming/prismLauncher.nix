{
  my.apps._.prismlauncher = {
    nixos = {
      # Allow connections from devices on local network (for purposes of LAN)
      networking.firewall = {
        extraInputRules = ''
          ip saddr 192.168.0.0/24 tcp dport 50000-65535 accept
          ip saddr 192.168.0.0/24 udp dport 4445 accept
        '';
      };
    };
    homeManager = { pkgs, ... }: { home.packages = with pkgs; [ prismlauncher ]; };
  };
}
