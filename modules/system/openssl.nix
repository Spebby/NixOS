{
  my.system._.openssl = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ openssl ];
      };
  };
}
