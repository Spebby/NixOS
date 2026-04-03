{
  my.apps._.dev._.localsend = {
    nixos.programs.localsend.enable = true;
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.localsend ];
      };
  };
}
