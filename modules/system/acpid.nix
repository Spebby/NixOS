{
  my.system._.acpid = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ acpid ];
      };
  };
}
