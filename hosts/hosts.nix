# /hosts/hosts.nix

{
  rosso = {
    hostname = "rosso";
    system = "x86_64-linux";
    config = import ./rosso/configuration.nix;
    users = [
      "thom"
      "max"
    ];
    extraModules = [ ];
  };

  tink = {
    hostname = "tink";
    system = "x86_64-linux";
    config = import ./tink/configuration.nix;
    users = [ "max" ];
    extraModules = [ ];
  };
}
